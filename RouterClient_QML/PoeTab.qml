import QtQuick 2.0
import QtQuick.Controls 1.2

Tab {
    id: poeTabId
    active: true
    title: qsTr("poe_tab")

    Connections {
        target: socketcontroller
    }
}
