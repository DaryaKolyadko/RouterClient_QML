import QtQuick 2.0
import QtQuick.Controls 1.2

Tab {
    id: portTrankSetupSubtabId
    active: true
    title: qsTr("port_trunk_setup")

    Connections {
        target: socketcontroller
    }
}
