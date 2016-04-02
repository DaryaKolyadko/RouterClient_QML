import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item {
    id: portsTabId

    Connections {
        target: socketcontroller
    }

    TabView{
        anchors.fill: parent

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
            objectName: "portTrunkSetupSubtab"
            anchors.fill: parent
        }
    }
}
