import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4

ApplicationWindow {
    id: appWindow
    visible: true
    width: 520
    height: 250
    title: qsTr("Авторизация")

//    menuBar: MenuBar {
//        Menu {
//            title: qsTr("File")
//            MenuItem {
//                text: qsTr("&Open")
//                onTriggered: console.log("Open action triggered");
//            }
//            MenuItem {
//                text: qsTr("Exit")
//                onTriggered: Qt.quit();
//            }
//        }
//    }

    GridLayout {
        id: gridLayoutStopWatch
        columns: 3
        anchors.centerIn: parent
        width: appWindow.width*8/9

        Text{
            id: loginText
            font.bold: true
            font.letterSpacing: 1
            font.pointSize: (appWindow.height + appWindow.width)/70
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: qsTr("Логин:")
        }

        TextField {
            id: loginTextInput
            font.letterSpacing: 1
            font.pointSize: (appWindow.height + appWindow.width)/70
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
            style: textFieldStyle
        }

        Text{
            id: passwordText
            font.bold: true
            font.letterSpacing: 1
            font.pointSize: (appWindow.height + appWindow.width)/70
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: qsTr("Пароль:")
        }

        TextField {
            id: passwordTextInput
            font.letterSpacing: 1
            font.pointSize: (appWindow.height + appWindow.width)/70
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
            style: textFieldStyle

            echoMode: TextInput.Password
        }

        Text{
            id: hostAddressText
            font.bold: true
            font.letterSpacing: 1
            font.pointSize: (appWindow.height + appWindow.width)/70
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: qsTr("Адрес хоста:")
        }

        TextField {
            id: hostAddressTextInput
            font.letterSpacing: 1
            font.pointSize: (appWindow.height + appWindow.width)/70
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
            style: textFieldStyle
            validator: RegExpValidator{
                regExp: /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
            }
        }

        Button {
            id: loginInButton
            text: qsTr("Войти")
            Layout.columnSpan: 3
            Layout.fillWidth: true

            onClicked: {
                //TODO open new form
            }
        }
    }

    // service elements

        MessageDialog {
            id: messageDialog
            title: qsTr("Важно")

            function show(caption) {
                messageDialog.text = caption;
                messageDialog.open();
            }
        }

        Component {
            id: textFieldStyle
            TextFieldStyle
            {
                textColor: "black"
                background: Rectangle {
                    radius: height/4
                    border.color: "lightgrey"
                    border.width: 2
                }
            }
        }
}
