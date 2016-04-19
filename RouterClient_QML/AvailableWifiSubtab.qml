import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ScrollView {
    id:availableWifiId
    implicitWidth: 650
    implicitHeight: 200
    clip: true
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    property var wifiConnectedIndexes : []
    property string connectedStr : qsTr("connected")
    property int fontCoefficient: 100
    property string greenTickImg: "images/check36x36.png"
    property string greyTickImg: "images/greycheck36x36.png"
    property alias innerContent: content
    property alias wifiConnectionWarningDialog: wifiConnectWarningDialog

    function addWifiConnectedIndexes(indexList)
    {
        availableWifiId.wifiConnectedIndexes = [];

        for (var i = 0; i < indexList.length; i++)
        {
            availableWifiId.wifiConnectedIndexes.push(indexList[i]);
        }
    }

    Item {
        id: content
        width: Math.max(availableWifiId.viewport.width, availableWifi.implicitWidth + 2 * availableWifi.rowSpacing)
        height: Math.max(availableWifiId.viewport.height, availableWifi.implicitHeight + 2 * availableWifi.columnSpacing)

        Connections {
            target: socketcontroller
        }

        WarningDialog{
            id: wifiConnectWarningDialog

            function doAction()
            {
                wifiPasswordDialog.show(wifiConnectionsModel.getChild(
                                            availableWifiRepeater.currentIndex).ssid);
            }
        }

        InfoMessageDialog{
            id: infoMessageDialog
        }

        LogOutDialog{
            id: logoutDialog
        }

        ErrorInfoDialog{
            id: errorMessageDialog

            function doAction()
            {
                socketcontroller.logOutSignal();
            }
        }

        WifiPasswordDialog{
            id: wifiPasswordDialog

            function doAction()
            {
                var result = socketcontroller.connectToWifi(
                            wifiConnectionsModel.getChild(
                                availableWifiRepeater.currentIndex).ssid,
                            getPassword());

                if (result === 1)
                {
                    infoMessageDialog.show(qsTr("wifi_connect_ok"));
                    socketcontroller.getInfoAboutWifiConnections();
                }
                else if (result === 0)
                {
                    errorMessageDialog.show(qsTr("wifi_connect_error"));
                    socketcontroller.getInfoAboutWifiConnections();
                }
                else
                {
                    logoutDialog.show(qsTr("connection_lost"));
                }
            }
        }

        GridLayout{
            id: availableWifi
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: availableWifiId.width*0.04
            anchors.rightMargin: availableWifi.rowSpacing
            anchors.topMargin: availableWifi.columnSpacing
            clip: true

            ExclusiveGroup {
                id: wifiExclusiveGroup
            }

            Column{
                spacing:availableWifiId.width*0.06

                Repeater{
                    id: availableWifiRepeater
                    objectName: "availableWifiRepeater"
                    model: wifiConnectionsModel
                    property int currentIndex: -1

                    onCurrentIndexChanged: {
                        checkConnectionButtonStatus();
                    }

                    function checkConnectionButtonStatus()
                    {
                        var connectionIndex = availableWifiRepeater.currentIndex;

                        if (availableWifiId.wifiConnectedIndexes.indexOf(connectionIndex) > -1)
                            socketcontroller.setWifiConnectButtonState(false);
                        else
                            socketcontroller.setWifiConnectButtonState(true);
                    }

                    Row{
                        Column{
                            RadioButton{
                                id: radio
                                exclusiveGroup: wifiExclusiveGroup

                                onCheckedChanged: {
                                    if(checked)
                                        availableWifiRepeater.currentIndex = index;
                                }
                            }
                        }

                        Column {
                            spacing: 8

                            Row{
                                Text {
                                    text: " " + ssid
                                    color: "darkGreen"
                                    font.pointSize:(availableWifiId.viewport.height + availableWifiId.width)/(fontCoefficient - 10)
                                }
                            }
                            Row{
                                Text {
                                    text: qsTr("state")
                                    font.pointSize:(availableWifiId.viewport.height + availableWifiId.width)/fontCoefficient
                                }
                                Image {
                                    id: image
                                    source: wifi_state
                                    height: (availableWifiId.viewport.height + availableWifiId.width)/(fontCoefficient/2.5)
                                    width: height
                                }
                            }
                            Row{
                                Text {
                                    text: qsTr("rate")
                                    font.pointSize:(availableWifiId.viewport.height + availableWifiId.width)/fontCoefficient
                                }
                                Text {
                                    text: rate
                                    font.pointSize:(availableWifiId.viewport.height + availableWifiId.width)/fontCoefficient
                                }
                            }
                            Row{
                                Text {
                                    text: qsTr("bars")
                                    font.pointSize:(availableWifiId.viewport.height + availableWifiId.width)/fontCoefficient
                                }
                                Text {
                                    text: bars
                                    font.pointSize:(availableWifiId.viewport.height + availableWifiId.width)/fontCoefficient
                                }
                            }
                            Row{
                                Text {
                                    text: qsTr("security")
                                    font.pointSize:(availableWifiId.viewport.height + availableWifiId.width)/fontCoefficient
                                }
                                Text {
                                    text: security
                                    font.pointSize:(availableWifiId.viewport.height + availableWifiId.width)/fontCoefficient
                                }
                            }
                        }
                    }
                }
            }
        }

        ListModel{
            id: wifiConnectionsModel
            objectName: "wifiConnectionsModel"

            function addWifiConnection(ssid_, state_, rate_, bars_,
                                       security_)
            {
                var conn = state_ ? greenTickImg : greyTickImg;
                append({ssid: ssid_, wifi_state: conn, rate: rate_,
                           bars: bars_, security: security_})
            }

            function getChild(index)
            {
                return get(index)
            }
        }
    }
}
