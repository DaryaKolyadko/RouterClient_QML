import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item {
    id: portsTabId

    Connections {
        target: socketcontroller
    }

    function redirectToFirstTab()
    {
        portsTabView.currentIndex  = 0;
    }

    TabView{
        id: portsTabView
        anchors.fill: parent

        PortStatusTab{
            id: portStatusTab
            objectName: "portStatusTab"
            anchors.fill: parent
        }

        PortSetupTab{
            id: portSetupSubtab
            objectName: "portSetupTab"
            anchors.fill: parent
        }

        PortStatusCountersTab{
            id: portStatusCountersTab
            objectName: "portStatusCountersTab"
            anchors.fill: parent
        }


        PortTrunkSetupSubtab{
            id: portTrunkSetupSubtab
            objectName: "portTrunkSetupSubtab"
            anchors.fill: parent
        }
    }
}
