import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

Item {
    id: corporationInfoTab
    property int fontCoefficient: 90

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
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
            }
        }
    }
}
