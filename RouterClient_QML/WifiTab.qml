import QtQuick 2.0
import QtQuick.Controls 1.2

Item {
    id: wifiTabId

    Connections {
        target: socketcontroller
    }

    TabView{
        anchors.fill: parent
        id: wifiTabInnerTabView
        objectName: "wifiTabInnerTabView"

        WifiConfigurationSubtab{
            id: wifiConfigurationSubtab
            objectName: "wifiConfigurationSubtab"
            active: true
            anchors.fill: parent
        }

        AvailableWifiSubtab{
            id: availableWifiSubtab
            objectName: "availableWifiSubtab"
            active: true
            anchors.fill: parent
        }

    }
}
