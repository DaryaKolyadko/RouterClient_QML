import QtQuick 2.0
import QtQuick.Controls 1.2

Tab {
    id: vlanSetupTabId
    active: true
    title: qsTr("vlan_setup")

    Connections {
        target: socketcontroller
    }
}
