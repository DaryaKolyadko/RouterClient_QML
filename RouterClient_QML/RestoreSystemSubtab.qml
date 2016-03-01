import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab {
    id: restoreSystemSubtabId
    active: true
    title: qsTr("restore_system")

    Connections {
        target: socketcontroller
    }

    ColumnLayout{
        anchors.fill: parent

        GridLayout{
            anchors.centerIn: parent
            columns: 1

            Text{
                text:qsTr("restore_system_text")
            }

            Button{
                id: rebootButton
                objectName: "restoreButton"
                text: qsTr("restore_system_now")
                onClicked: {
                        restoreSystemDialog.show(qsTr("restore_system_dialog"))
                    }
                }

                WarningDialog{
                    id: restoreSystemDialog

                    function doAction()
                    {
                        // TODO
                    }
                }
            }
        }
    }
