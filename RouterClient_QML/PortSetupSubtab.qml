import QtQuick 2.0
import QtQuick.Controls 1.2

Tab {
    id: portSetupSubtabId
    active: true
    title: qsTr("port_setup")

    Connections {
        target: socketcontroller
    }
}
