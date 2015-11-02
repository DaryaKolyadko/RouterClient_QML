import QtQuick 2.0
import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4

ApplicationWindow {
    id: appWindowMain
    visible: true
    width: 800
    height: 400
    title: qsTr("Настройка ")

    TabView{
        id: tabView
        anchors.fill: parent

        Tab{
            id: configuration
            title: qsTr("Основные настройки")
            GridLayout {
                id: gridLayoutMainConfig
                columns: 3
                anchors.centerIn: parent
                width: appWindowMain.width*2/3

                Text{
                    id: hostAddressText
                    font.bold: true
                    font.letterSpacing: 1
                    font.pointSize: (appWindow.height + appWindow.width)/100
                    Layout.fillWidth: true
                    text: qsTr("Адрес хоста:")
                }

                TextField {
                    id: hostAddressTextInput
                    font.letterSpacing: 1
                    font.pointSize: (appWindow.height + appWindow.width)/100
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    style: textFieldStyle
                    enabled: false
                    validator: RegExpValidator{
                        regExp: /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
                    }
                }

                Text{
                    id: networkMaskText
                    font.bold: true
                    font.letterSpacing: 1
                    font.pointSize: (appWindow.height + appWindow.width)/100
                    Layout.fillWidth: true
                    text: qsTr("Маска подсети:")
                }

                TextField {
                    id:networkMaskTextInput
                    font.letterSpacing: 1
                    font.pointSize: (appWindow.height + appWindow.width)/100
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    style: textFieldStyle
                    enabled: false
                    validator: RegExpValidator{
                        regExp: /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
                    }
                }

                Text{
                    id: macAddressText
                    font.bold: true
                    font.letterSpacing: 1
                    font.pointSize: (appWindow.height + appWindow.width)/100
                    Layout.fillWidth: true
                    text: qsTr("MAC-адрес:")
                }

                TextField {
                    id:macAddressTextInput
                    font.letterSpacing: 1
                    font.pointSize: (appWindow.height + appWindow.width)/100
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    style: textFieldStyle
                   // enabled: false
                    validator: RegExpValidator{
                        regExp: /\b(^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$)\b/
                    }
                }

////                Button {
////                    id: loginInButton
////                    text: qsTr("Войти")
////                    Layout.columnSpan: 3
////                    Layout.fillWidth: true

////                    onClicked: {

////                    }

////                    }
////
//            }
            }

//        Tab{
//    GridLayout {
//        id: gridLayoutStopWatch
//        columns: 3
//        anchors.centerIn: parent
//        width: appWindow.width*8/9

//        Text{
//            id: loginText
//            font.bold: true
//            font.letterSpacing: 1
//            font.pointSize: (appWindow.height + appWindow.width)/70
//            Layout.fillWidth: true
//            Layout.fillHeight: true
//            text: qsTr("Логин:")
//        }

//        TextField {
//            id: loginTextInput
//            font.letterSpacing: 1
//            font.pointSize: (appWindow.height + appWindow.width)/70
//            Layout.columnSpan: 2
//            Layout.fillWidth: true
//            Layout.fillHeight: true
//            style: textFieldStyle
//        }

//        Text{
//            id: passwordText
//            font.bold: true
//            font.letterSpacing: 1
//            font.pointSize: (appWindow.height + appWindow.width)/70
//            Layout.fillWidth: true
//            Layout.fillHeight: true
//            text: qsTr("Пароль:")
//        }

//        TextField {
//            id: passwordTextInput
//            font.letterSpacing: 1
//            font.pointSize: (appWindow.height + appWindow.width)/70
//            Layout.columnSpan: 2
//            Layout.fillWidth: true
//            Layout.fillHeight: true
//            style: textFieldStyle
//            echoMode: TextInput.Password
//        }

//        Text{
//            id: hostAddressText
//            font.bold: true
//            font.letterSpacing: 1
//            font.pointSize: (appWindow.height + appWindow.width)/70
//            Layout.fillWidth: true
//            Layout.fillHeight: true
//            text: qsTr("Адрес хоста:")
//        }

//        TextField {
//            id: hostAddressTextInput
//            font.letterSpacing: 1
//            font.pointSize: (appWindow.height + appWindow.width)/70
//            Layout.columnSpan: 2
//            Layout.fillWidth: true
//            Layout.fillHeight: true
//            style: textFieldStyle
//            validator: RegExpValidator{
//                regExp: /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
//            }
//        }

//        Button {
//            id: loginInButton
//            text: qsTr("Войти")
//            Layout.columnSpan: 3
//            Layout.fillWidth: true

//            onClicked: {
////                var login = loginTextInput.getText();
////                var password = passwordTextInput.getText()
////                var host = hostAddressTextInput.getText();
////                var port = 8080;
////                var socket = new jSocket()

//                //TODO open new form
//               // var socket = io();
//            //                // Tell the server your username
//            //                socket.emit('add user', loginTextInput.getText());
//            //                // tell server to execute 'new message' and send along one parameter
//            //                socket.emit('new message', message);



////                var socket = Socket.require('socket.io-client')('http://localhost');//io('http://localhost');
////                socket.on('connect', function(){});
////                socket.on('event', function(data){});
////                socket.on('disconnect', function(){});
////                socket.emit('auth', loginTextInput.getText() + ' ' + passwordTextInput.getText() + ' ' +
////                            hostAddressTextInput.getText());
//                var login = loginTextInput.getText();
//                var password = passwordTextInput.getText()
//                appSocket.url = hostAddressTextInput.getText()
//                appSocket.sendTextMessage(login + qsTr(" ") + password)
//                var component = Qt.createComponent("mainform.qml")
//                var window = component.createObject(appWindow)
//                window.show()
//                appWindow.hide()
//            }
//        }
    }
//}
    // service elements
}
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
