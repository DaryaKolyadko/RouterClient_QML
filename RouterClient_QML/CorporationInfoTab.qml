import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

Item {
    id: corporationInfoTab

    Connections {
        target: socketcontroller
    }

    ColumnLayout{
        anchors.fill: parent

        GridLayout{
            anchors.centerIn: parent
            columns: 1

            Text{
                id: corporationInfoText
                objectName: "corporationInfoText"
            }
        }
    }
}
