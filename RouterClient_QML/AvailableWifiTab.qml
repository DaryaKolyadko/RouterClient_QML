import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.0

Tab {
    id: availableWifiTabId
    active: true
    title: qsTr("available_wifi")
    property var wifiConnectedIndexes : [-1]
    property string connectedStr : qsTr("connected")

    Connections {
        target: socketcontroller
    }

    function addWifiConnectedIndexes(indexList)
    {
        for (var i = 0; i < indexList.length; i++)
        {
            availableWifiTabId.wifiConnectedIndexes.push(indexList[i]);
        }
    }

    ColumnLayout{

        RowLayout{
            WarningDialog{
                id: wifiConnectWarningDialog

                function doAction()
                {
                    //could server sent result...?
                    //TODO
                    var result = socketcontroller.connectToWifi(availableWifiTab.wifiConnectedIndex);

                    if (result == 1)
                    {
                        infoMessageDialog.show(qsTr("wifi_connect_ok"));
                    }
                    else
                    {
                        errorMessageDialog.show(qsTr("wifi_connect_error"));
                        socketcontroller.getInfoAboutWifiConnections();
                    }
                }
            }

            InfoMessageDialog{
                id: infoMessageDialog

                function doAction()
                {
                    socketcontroller.logOut();
                }
            }

            ErrorInfoDialog{
                id: errorMessageDialog
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

        TableView{
            id: wifiTableView
            objectName: "wifiTableView"
            Layout.fillWidth: true
            model: wifiConnectionsModel
            property int coefficient: 4
            property int colWidth: wifiTableView.viewport.width / coefficient

            Connections{
                target: wifiTableView.selection
                onSelectionChanged: wifiTableView.checkConnectionButtonStatus()
            }

            function checkConnectionButtonStatus()
            {
                var connectionIndex = wifiTableView.currentRow;

                if (availableWifiTab.wifiConnectedIndexes.indexOf(connectionIndex) > -1)
                    connectToWifiButton.enabled = false;
                else
                    connectToWifiButton.enabled = true;
            }

            TableViewColumn{
                id: ssidColumn
                title: qsTr("ssid_table_title")
                role: "ssid"
                movable: false
                resizable: true
                width: wifiTableView.colWidth
            }

            TableViewColumn {
                id: stateColumn
                title: qsTr("state")
                role: "state"
                movable: false
                resizable: true
                width: wifiTableView.colWidth
            }

            TableViewColumn {
                id: rateColumn
                title: qsTr("rate")
                role: "rate"
                movable: false
                resizable: true
                width: wifiTableView.colWidth / 2
            }

            TableViewColumn {
                id: barsColumn
                title: qsTr("bars")
                role: "bars"
                movable: false
                resizable: true
                width: wifiTableView.colWidth / 2
            }

            TableViewColumn {
                id: securityColumn
                title: qsTr("security")
                role: "security"
                movable: false
                resizable: true
                width: wifiTableView.colWidth
            }
        }

        ListModel{
            id: wifiConnectionsModel
            objectName: "wifiConnectionsModel"

            function addWifiConnection(ssid_, state_, rate_, bars_,
                                       security_)
            {
                var conn = state_ ? connectedStr : "";
                append({ssid: ssid_, state: conn, rate: rate_,
                           bars: bars_, security: security_})
            }

            function getChild(index)
            {
                return get(index)
            }
        }
    }
}
