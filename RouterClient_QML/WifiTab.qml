import QtQuick 2.0
import QtQuick.Controls 1.2

Item {
    id: wifiTabId

    Connections {
        target: socketcontroller
    }

    function redirectToFirstTab()
    {
        wifiTabInnerTabView.currentIndex  = 0;
    }

    TabView{
        id: wifiTabInnerTabView
        objectName: "wifiTabInnerTabView"
        anchors.fill: parent

        WifiConfigurationTab{
            id: wifiConfigurationTab
            objectName: "wifiConfigurationTab"
            anchors.fill: parent
        }

        AvailableWifiTab{
            id: availableWifiTab
            objectName: "availableWifiTab"
            active: true
            anchors.fill: parent
        }

    }
}
