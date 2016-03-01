import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.0

Tab {
    id: firmwareUpgradeSubtabId
    active: true
    title: qsTr("firmware_upgrade")

    Connections {
        target: socketcontroller
    }
    ColumnLayout{
        anchors.fill: parent

        GridLayout{
            anchors.centerIn: parent
            columns: 2

            Rectangle{
                color: "red"
                border.color: "black"
                border.width: 1
                radius: 4
                Layout.columnSpan: 2

                Text{
                    id: firmwareUpgradeText
                    text:qsTr("firmware_upgrade_text")
                    anchors.centerIn: parent
                }

                width: firmwareUpgradeText.width + 20
                height: firmwareUpgradeText.height + 20
            }

            Text{
                text: qsTr("bin_file_choose_text")
            }

            Button{
                text: qsTr("choose_file")
                onClicked: {
                    fileDialog.open()
                }
            }

            ChooseFileDialog {
                id: fileDialog
            }

            Button{
                id: firmwareUpgradeButton
                objectName: "firmwareUpgradeButton"
                text: qsTr("firmware_upgrade_now")
                Layout.columnSpan: 2
                onClicked: {
                    firmwareUpgradeDialog.show(qsTr("firmware_upgrade_dialog"))
                }
            }

            WarningDialog{
                id: firmwareUpgradeDialog

                function doAction()
                {
                    // TODO
                }
            }
        }
    }
}
