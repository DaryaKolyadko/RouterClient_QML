import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab{
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

    ColumnLayout{
        id: columnLayout

        RowLayout{
            id: rowLayoutId
            Layout.fillWidth: true
            anchors.top: parent.top

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
                objectName: "connectToWifiButton"
                text: qsTr("connect_to_wifi")
                Layout.fillWidth: true
                enabled: false
                onClicked: {
                    availableWifiSubtab.wifiConnectionWarningDialog.show(qsTr("connect_warning"))
                }
            }
        }

        ColumnLayout{
            anchors.top: rowLayoutId.bottom
            anchors.bottom: parent.bottom

            AvailableWifiSubtab{
                id: availableWifiSubtab
                objectName: "availableWifiSubtab"
                anchors.fill: parent
                clip: true
                Layout.fillWidth: true
            }
        }
    }
}
