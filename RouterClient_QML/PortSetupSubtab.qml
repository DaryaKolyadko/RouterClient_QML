import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab {
    id: portSetupSubtabId
    active: true
    title: qsTr("port_setup")

    Connections {
        target: socketcontroller
    }

    ColumnLayout{
        anchors.fill: parent

        Text{
            id: title
            text: qsTr("port_setup_title")
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
        }
    }
}
