import QtQuick 2.0
import QtQuick.Controls 1.2

Tab {
    id: portsTabId
    active: true
    title: qsTr("ports_tab")

    Connections {
        target: socketcontroller
    }

    TabView{
        PortStatusSubtab{
            id: portStatusSubtab
            objectName: "portStatusSubtab"
            anchors.fill: parent
        }

        PortSetupSubtab{
            id: portSetupSubtab
            objectName: "portSetupSubtab"
            anchors.fill: parent
        }

        PortStatusCountersSubtab{
            id: portStatusCountersSubtab
            objectName: "portStatusCountersSubtab"
            anchors.fill: parent
        }

        PortTrunkSetupSubtab{
            id: portTrunkSetupSubtab
            objectName: "portStatusCountersSubtab"
            anchors.fill: parent
        }
    }
}
