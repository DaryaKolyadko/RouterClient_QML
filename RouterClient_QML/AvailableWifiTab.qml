import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.0

Tab {
    id: availableWifiTabId
    active: true
    title: qsTr("available_wifi")

    ColumnLayout{

        RowLayout{
            Button{
                id: updateAvailableWifiButton
                text: qsTr("update_wifi_list")
                Layout.fillWidth: true
                onClicked: {
                    //TODO
                }
            }

            Button{
                id: connectToWifiButton
                text: qsTr("connect_to_wifi")
                Layout.fillWidth: true
                onClicked: {
                    //TODO
                }
            }
        }

        TableView{
            id: wifiTableView
            Layout.fillWidth: true
            property int count: 4
            property int colWidth: wifiTableView.viewport.width / count


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
                       wifiTableView.colWidth*(wifiTableView.count - 1)
            }
        }
    }
}
