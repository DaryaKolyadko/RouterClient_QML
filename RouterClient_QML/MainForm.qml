import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4
import QtWebSockets 1.0

ApplicationWindow {
    id: appWindow
    objectName: "appWindow"
    visible: true
    minimumWidth: 635
    minimumHeight: 295
    width: minimumWidth
    height: minimumHeight
    title: qsTr("Авторизация")

    Connections{
        target: socketcontroller
    }

    LoginForm{
        id: mainLoginForm
        objectName: "mainLoginForm"
        anchors.fill: parent
        visible: true

        onVisibleChanged: {
            pageChanged()
        }
    }

    ConfigurationForm {
        id: mainConfigurationForm
        objectName: "mainConfigurationForm"
        property alias mainConfigForm: mainConfigurationForm
        anchors.fill: parent
        visible: false
    }

    function pageChanged () {
        if (mainLoginForm.visible)
        {
            title = qsTr("Авторизация");
            mainConfigurationForm.visible = false;
            statusBar.visible = false;
        }
        else
        {
            title = qsTr("Настройка ");
            mainConfigurationForm.visible = true;

            statusBar.visible = true;
        }
    }

    statusBar: StatusBar {
        id: statusBar
        visible: false
        RowLayout {
            anchors.fill: parent
            Label {
                id: labelStatus
                text: mainLoginForm.login
                Layout.alignment: Qt.AlignLeft
            }

            Button{
                text: qsTr("Выйти")
                Layout.alignment: Qt.AlignRight
                onClicked: {
                    mainLoginForm.visible = true
                    socketcontroller.close();
                }
            }
        }
    }


//    Item
//    {
//        anchors.fill: parent
//        Rectangle {
//               id: rectangle
//               border.color: "green"
//               anchors.fill: parent
//           }

//        Combobox{
//        }
    }

//    visible: true
//    width: 520
//    height: 250
//    Item {
//        id: wind1
//        visible: false
//        anchors.fill: parent
//        Text {
//            id: name
//            text: qsTr("Window1")
//            anchors.centerIn: parent
//        }
//        MouseArea {
//            anchors.fill: parent
//            onPressed: {
//                wind1.visible = false;
//                wind2.visible = true;

//            }
//        }
//    }
//    Item {
//        id: wind2
//        visible: true
//        anchors.fill: parent
//        Text {
//            text: qsTr("Window2")
//            anchors.centerIn: parent
//        }
//        Combobox{

//        }

//        MouseArea {
//            anchors.fill: parent
//            onPressed: {
////                wind2.visible = false;
////                wind1.visible = true;

//            }
//        }

//    }

//        Item{
//            id: loginFormGlobal
//            anchors.fill: parent
//        }
 //}
