import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.0

Tab {
    id: availableWifiTabId
    active: true
    title: qsTr("available_wifi")
    property int wifiConnectedIndex: -1

    Connections {
        target: socketcontroller
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
                        infoMessageDialog.show("wifi_connect_ok");
                    }
                    else
                    {
                        errorMessageDialog.show("wifi_connect_error");
                        socketcontroller.getInfoAboutWifiConnections();
                    }
                }
            }

            InfoMessageDialog{
                id: infoMessageDialog

                function doAction()
                {
                    socketcontroller.close();
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
                    wifiConnectWarningDialog.show("connect_warning")
                }
            }
        }

        TableView{
            id: wifiTableView
            Layout.fillWidth: true
            model: wifiConnectionsModel
            property int colCount: 4
            property int colWidth: wifiTableView.viewport.width / colCount

            Connections{
                target: wifiTableView.selection
                onSelectionChanged: wifiTableView.checkConnectionButtonStatus()
            }

            function checkConnectionButtonStatus()
            {
                var connectionIndex = wifiTableView.currentRow;

                if (connectionIndex == availableWifiTab.wifiConnectedIndex)
                    connectToWifiButton.enabled = false;
                else
                    connectToWifiButton.enabled = true;
            }

            TableViewColumn{
                id: deviceColumn
                title: qsTr("device")
                role: "device"
                movable: false
                resizable: true
                width: wifiTableView.colWidth
            }

            TableViewColumn {
                id: typeColumn
                title: qsTr("type")
                role: "type"
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
                id: connectionColumn
                title: qsTr("connection")
                role: "connection"
                movable: false
                resizable: true
                width: wifiTableView.viewport.width -
                       wifiTableView.colWidth*(wifiTableView.colCount - 1)
            }
        }

        ListModel{
            id: wifiConnectionsModel
            objectName: "wifiConnectionsModel"

            function addWifiConnection(device_, type_, state_, connection_)
            {
                append({device: device_, type:type_, state: state_,
                           connection: connection_})
            }

            function getChild(index)
            {
                return get(index)
            }
        }
    }
}
