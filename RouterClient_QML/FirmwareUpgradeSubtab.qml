import QtQuick 2.5
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.0

Tab {
    id: firmwareUpgradeSubtabId
    active: true
    title: qsTr("firmware_upgrade")

    property int fontCoefficient: 110

    Connections {
        target: socketcontroller
    }

    ColumnLayout{
        id: columnLayout
        anchors.fill: parent

        GridLayout{
            anchors.centerIn: parent
            columns: 2

            Rectangle{
                id: rect
                color: "transparent"
                height: columnLayout.height*0.45
                width: columnLayout.width*0.85
                anchors.bottomMargin: 10

                Text{
                    id: firmwareUpgradeText
                    anchors.centerIn: parent
                    color: "red"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    text:qsTr("firmware_upgrade_text")
                    wrapMode: Text.Wrap
                    width: columnLayout.width*0.88
                    font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                }
            }

            RowLayout{
                id: rowLayout
                Layout.columnSpan: 2

                Rectangle{
                    id: rectInner
                    height: (firmwareUpgradeSubtabId.height + firmwareUpgradeSubtabId.width)/fontCoefficient
                    width: parent.parent.width*0.7
                    color: "transparent"
                    anchors.bottomMargin: 10

                    Text{
                        id: innerText
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.Wrap
                        width: firmwareUpgradeSubtabId.width*0.65
                        text: qsTr("bin_file_choose_text")
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                    }
                }

                Button{
                    text: qsTr("choose_file")
                    onClicked: {
                        fileDialog.open()
                    }
                }
            }

            InfoMessageDialog {
                id: infoMessageDialog
            }

            ErrorInfoDialog{
                id: errorInfoDialog
            }

            ChooseFileDialog {
                id: fileDialog

                function doAction()
                {
                    innerText.text = filePath;
                }
            }

            Button{
                id: firmwareUpgradeButton
                anchors.top: rowLayout.bottom
                objectName: "firmwareUpgradeButton"
                text: qsTr("firmware_upgrade_now")
                onClicked: {
                    firmwareUpgradeDialog.show(qsTr("firmware_upgrade_dialog"))
                }
            }

            WarningDialog{
                id: firmwareUpgradeDialog

                function doAction()
                {
                    if(fileDialog.filePath == "")
                    {
                        infoMessageDialog.show("please_choose_file");
                        return;
                    }

                    var res = socketcontroller.sendFile(fileDialog.filePath);
                    fileDialog.filePath = "";

                    if(res === 1)
                        infoMessageDialog.show("upgrade_was_sent");
                    else if (res === 0)
                    {
                        errorInfoDialog.show("upgrade_was_not_sent_connection_lost");
                        socketcontroller.logOutSignal();
                    }
                    else if (res === -1)
                        errorInfoDialog.show("problem_with_file");

                    innerText.text = qsTr("bin_file_choose_text");
                }
            }
        }
    }
}
