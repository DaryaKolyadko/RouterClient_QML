import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item {
    id: poeTabId

    Connections {
        target: socketcontroller
    }

    ColumnLayout{
        anchors.fill: parent

        Text{
            id: title
            text: qsTr("poe_tab_title")
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
        }
    }
}
