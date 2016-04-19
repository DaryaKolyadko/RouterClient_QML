import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab{
    id: portStatusSubtabId
    active: true
    title: qsTr("port_status")

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
                id: updatePortStatusListButton
                text: qsTr("update_port_status_list")
                Layout.fillWidth: true
                onClicked: {
                    socketcontroller.getPortStatusList();
                }
            }
        }

        ColumnLayout{
            anchors.top: rowLayoutId.bottom
            anchors.bottom: parent.bottom

            PortStatusSubtab{
                id: portStatusSubtab
                objectName: "portStatusSubtab"
                anchors.fill: parent
                clip: true
                Layout.fillWidth: true
            }
        }
    }
}
