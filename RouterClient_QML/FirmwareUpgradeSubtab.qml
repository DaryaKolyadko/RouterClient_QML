import QtQuick 2.5
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.0

Tab {
    id: firmwareUpgradeSubtabId
    active: true
    title: qsTr("firmware_upgrade")

    property int fontCoefficient: 100

    Connections {
        target: socketcontroller
    }
    ColumnLayout{
        anchors.fill: parent
        ColumnLayout{

//        GridLayout{
            anchors.centerIn: parent
//            columns: 2

            Rectangle{
                id: rect
                color: "red"
                height: parent.parent.height*0.5
                width: parent.parent.width*0.85
                border.color: "black"
                border.width: 1
                radius: 4
                anchors.bottomMargin: 10

                Text{
                    id: firmwareUpgradeText
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    text:qsTr("firmware_upgrade_text")
                    wrapMode: Text.Wrap
                    width: firmwareUpgradeSubtabId.width*0.8
                    font.pointSize: (parent.parent.parent.height + parent.parent.parent.width)/fontCoefficient
                }
            }

//            Rectangle {
//                id: rect
//                width: text.width
//                height: text.height
//                color: "red"
//            RowLayout{
//                id: firstRowLayout
//               // Layout.columnSpan: 2

//                Text {
//                    id: text
//                    text: qsTr("firmware_upgrade_text")
//                    wrapMode: Text.Wrap
//                    //Layout.columnSpan: 2
////                    color: "red"
////                    font.bold: true
//                    width: parent.parent.parent.width*0.8
//                   // font.pointSize: (parent.parent.parent.height + parent.parent.parent.width)/fontCoefficient
//                }
//            }
//           // }

            RowLayout{
                id: rowLayout

                Text{
                    text: qsTr("bin_file_choose_text")
                   // anchors.top: firmwareUpgradeText.bottom
                    font.pointSize: (parent.parent.parent.height + parent.parent.parent.width)/fontCoefficient
                }

                Button{
                    text: qsTr("choose_file")
                   // anchors.top: firmwareUpgradeText.bottom
                    onClicked: {
                        fileDialog.open()
                    }
                }
            }

            ChooseFileDialog {
                id: fileDialog
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
                    // TODO
                }
            }
        }
    }
}
