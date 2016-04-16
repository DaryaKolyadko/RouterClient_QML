import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab {
    id: rebootSystemSubtabId
    active: true
    title: qsTr("reboot_system")

    Connections {
        target: socketcontroller
    }

    ColumnLayout{
        anchors.fill: parent

        GridLayout{
            anchors.centerIn: parent
            columns: 1

            Text{
                text:qsTr("reboot_system_text")
                font.pointSize: (parent.parent.parent.height + parent.parent.parent.width)/fontCoefficient
            }

            Button{
                id: rebootButton
                objectName: "rebootButton"
                text: qsTr("reboot_system_now")
                onClicked: {
                    rebootSystemDialog.show(qsTr("reboot_system_dialog"))
                }
            }

            WarningDialog{
                id: rebootSystemDialog

                function doAction()
                {
                    socketcontroller.rebootSystem();
                    socketcontroller.logOutSignal();
                }
            }
        }
    }
}
