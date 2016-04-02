import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.0

Tab {
    id: availableWifiTabId
    active: true
    title: qsTr("available_wifi")
    property var wifiConnectedIndexes : []
    property string connectedStr : qsTr("connected")
    property string greenTickImg: "images/check36x36.png"
    property string greyTickImg: "images/greycheck36x36.png"

    Connections {
        target: socketcontroller
    }

    function addWifiConnectedIndexes(indexList)
    {
        availableWifiTabId.wifiConnectedIndexes = [];

        for (var i = 0; i < indexList.length; i++)
        {
            availableWifiTabId.wifiConnectedIndexes.push(indexList[i]);
        }
    }

    ColumnLayout{
        id: columnLayout

        RowLayout{
            id: rowLayoutId

            WarningDialog{
                id: wifiConnectWarningDialog

                function doAction()
                {
                    wifiPasswordDialog.show(wifiConnectionsModel.getChild(
                                                wifiConnectionsListView.currentIndex).ssid);
                }
            }

            InfoMessageDialog{
                id: infoMessageDialog
            }

            //            InfoMessageDialog{
            //                id: logoutDialog

            //                function doAction()
            //                {
            //                    socketcontroller.logOut();
            //                }
            //            }

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
                                    wifiTableView.currentRow).ssid,
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

            Button{
                id: updateAvailableWifiButton
                text: qsTr("update_wifi_list")
                Layout.fillWidth: true
                onClicked: {
                    socketcontroller.getInfoAboutWifiConnections();
                }
            }

            Button{
                id: connectToWifiButton
                text: qsTr("connect_to_wifi")
                Layout.fillWidth: true
                enabled: false
                onClicked: {
                    wifiConnectWarningDialog.show(qsTr("connect_warning"))
                }
            }
        }


        ColumnLayout{
            anchors.top: rowLayoutId.bottom
            anchors.left: columnLayout.left
            anchors.right: columnLayout.right
            anchors.bottom: columnLayout.bottom
            //           ScrollView{
            //         anchors.fill: parent

            Flickable{
                anchors.fill: parent
                flickableDirection: Flickable.VerticalFlick

                ListView{
                    id: wifiConnectionsListView
                    anchors.fill: parent
                    width: columnLayout.width
                    clip: true
                    model: wifiConnectionsModel
                    anchors.leftMargin: rowLayoutId.width*0.05
                    delegate: wifiConnectionListDelegate

                    function checkConnectionButtonStatus()
                    {
                        var connectionIndex = wifiConnectionsListView.currentIndex;

                        if (availableWifiTabId.wifiConnectedIndexes.indexOf(connectionIndex) > -1)
                            connectToWifiButton.enabled = false;
                        else
                            connectToWifiButton.enabled = true;
                    }

                    highlight: Rectangle
                    {
                    color: "#C4D9C5"
                    radius: 5
                    opacity: 0.7
                    focus: true
                    border.color: "green"
                    anchors.rightMargin: 15
                }

                onCurrentIndexChanged: {
                    checkConnectionButtonStatus();
                }
            }
            // }
        }
    }

    Component {
        id: wifiConnectionListDelegate

        Item {
            id: wifiConnectionListDelegateItem
            width: childrenRect.width //portStatusCountersListView.width
            anchors.bottomMargin: wifiConnectionsListView.width*0.02
            //height: childrenRect.height + 10
            height: ((columnLayout.height + columnLayout.width)/fontCoefficient)*20

            Row {
                ColumnLayout {
                    width: wifiConnectionsListView.width
                    //Layout.fillWidth: true

                    Row{
                        Text {
                            text: " " + ssid
                            color: "darkGreen"
                            font.pointSize:(columnLayout.height + columnLayout.width)/(fontCoefficient - 10)
                        }
                    }
                    Row{
                        Text {
                            text: qsTr("state")
                            font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                        }
                        Image {
                            id: image
                            source: wifi_state
                            height: (columnLayout.height + columnLayout.width)/(fontCoefficient/2.5)
                            width: height
                        }
                    }
                    Row{
                        Text {
                            text: qsTr("rate")
                            font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                        }
                        Text {
                            text: rate
                            font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                        }
                    }
                    Row{
                        Text {
                            text: qsTr("bars")
                            font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                        }
                        Text {
                            text: bars
                            font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                        }
                    }
                    Row{
                        Text {
                            text: qsTr("security")
                            font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                        }
                        Text {
                            text: security
                            font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                        }
                    }

                    //                        Rectangle
                    //                        {
                    //                            height: 1;
                    //                            width: columnLayout.width*0.8;
                    //                            color: "gray";
                    //                           // anchors.leftMargin: columnLayout.width*0.1
                    //                            anchors
                    //                            {
                    //                                left: parent.left;
                    //                                bottom: parent.bottom
                    //                            }
                    //                        }


                    MouseArea {
                        anchors.fill: parent

                        onClicked:{
                            wifiConnectionsListView.currentIndex = index;
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
