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

            Rectangle{
                id: rect
                height: parent.parent.height*0.5
                width: parent.parent.width*0.85
                border.color: "transparent"
                color: "transparent"
                anchors.bottomMargin: 10

                Text{
                    id: firmwareUpgradeText
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    text:qsTr("restore_system_text")
                    wrapMode: Text.Wrap
                    width: restoreSystemSubtabId.width*0.8
                    font.pointSize: (parent.parent.parent.height + parent.parent.parent.width)/fontCoefficient
                }
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
                        socketcontroller.restoreSystemDefault();
                        socketcontroller.logOutSignal();
                    }
                }
            }
        }
    }
