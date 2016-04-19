import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab{
    id: portStatusCountersSubtabId
    active: true
    title: qsTr("port_status_counters")

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
                id: updatePortStatusCountersListButton
                text: qsTr("update_port_status_counters_list")
                Layout.fillWidth: true
                onClicked: {
                    socketcontroller.getPortStatusCountersList();
                }
            }
        }

        ColumnLayout{
            anchors.top: rowLayoutId.bottom
            anchors.bottom: parent.bottom

            PortStatusCountersSubtab{
                id: portStatusCountersSubtab
                objectName: "portStatusCountersSubtab"
                anchors.fill: parent
                clip: true
                Layout.fillWidth: true
            }
        }
    }
}
