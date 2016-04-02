import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item {
    id: poeTabId

    Connections {
        target: socketcontroller
    }

    TabView{
        anchors.fill: parent

        PoeSubtab{
            id: poeSubtab
            objectName: "poeSubtab"
            anchors.fill: parent
        }
    }
}
