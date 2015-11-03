import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4
import QtWebSockets 1.0
//import "socket.io.js" as Socket

ApplicationWindow {
    id: appWindow
    visible: true
    width: 520
    height: 250
    title: qsTr("Авторизация")

    WebSocketServer {
        id: server
        listen: true
    //    port: "8080"
        onClientConnected: {
            webSocket.onTextMessageReceived.connect(
                        function(message) {
                            MessageDialog.show(qsTr("Server received message: %1").arg(message));
                            webSocket.sendTextMessage(qsTr("Hello Client!"));
                        });
        }
        onErrorStringChanged: {
             MessageDialog.show(qsTr("Server error: %1").arg(errorString));
        }
    }

    WebSocket {
            id: appSocket
            onTextMessageReceived: {
                MessageDialog.show(message)
//                var data = message;
//                var messages = root.messages;
//                if(data.message) {
//                    messages.push(data);
//                    var html = '';
//                    for(var i = 0; i < messages.length; i++) {
//                        html += '<b>' + (messages[i].username ? messages[i].username : 'Server') + ': </b>';
//                        html += messages[i].message + '<br />';
//                    }
//                    messageBox.append(html);
//                } else {
//                    messageBox.append("There is a problem:", data);
//                }
                if (socket.status == WebSocket.Error) {
                    messageDialog.show(qsTr("Ошибка: ") + socket.errorString)
                } else if (socket.status == WebSocket.Open) {
                    socket.sendTextMessage(qsTr("Hello World"))
                } else if (socket.status == WebSocket.Closed) {
                    messageDialog.show(qsTr("Соединение закрыто"))
                        }
            active: false
        }
    }

   /* menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: console.log("Open action triggered");
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }*/

    property int bottomMargin: 10
    property int fontСoefficient: 70

    GridLayout {
        id: gridLayoutStopWatch
        columns: 3
        anchors.centerIn: parent

        Text{
            id: loginText
            font.bold: true
            font.letterSpacing: 1
            font.pointSize: (appWindow.height + appWindow.width)/fontСoefficient
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.bottomMargin: bottomMargin
            text: qsTr("Логин:")
        }

        TextField {
            id: loginTextInput
            font.letterSpacing: 1
            font.pointSize: (appWindow.height + appWindow.width)/fontСoefficient
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.bottomMargin: bottomMargin
            style: textFieldStyle
        }

        Text{
            id: passwordText
            font.bold: true
            font.letterSpacing: 1
            font.pointSize: (appWindow.height + appWindow.width)/fontСoefficient
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.bottomMargin: bottomMargin
            text: qsTr("Пароль:")
        }

        TextField {
            id: passwordTextInput
            font.letterSpacing: 1
            font.pointSize: (appWindow.height + appWindow.width)/fontСoefficient
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
            style: textFieldStyle
            anchors.bottomMargin: bottomMargin
            echoMode: TextInput.Password
        }

        Text{
            id: hostAddressText
            font.bold: true
            font.letterSpacing: 1
            font.pointSize: (appWindow.height + appWindow.width)/fontСoefficient
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.bottomMargin: bottomMargin
            text: qsTr("Адрес хоста:")
        }

        TextField {
            id: hostAddressTextInput
            font.letterSpacing: 1
            font.pointSize: (appWindow.height + appWindow.width)/fontСoefficient
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
            style: textFieldStyle
            anchors.bottomMargin: bottomMargin
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
   /*             var login = loginTextInput.getText();
                var password = passwordTextInput.getText()
                var host = hostAddressTextInput.getText();
                var port = 8080;
                var socket = new jSocket()

                TODO open new form
                var socket = io();
                            // Tell the server your username
                            socket.emit('add user', loginTextInput.getText());
                            // tell server to execute 'new message' and send along one parameter
                            socket.emit('new message', message);*/


           /*     var socket = Socket.require('socket.io-client')('http://localhost');//io('http://localhost');
                socket.on('connect', function(){});
                socket.on('event', function(data){});
                socket.on('disconnect', function(){});
                socket.emit('auth', loginTextInput.getText() + ' ' + passwordTextInput.getText() + ' ' +
                            hostAddressTextInput.getText());*/


             /*   var login = loginTextInput.getText();
                var password = passwordTextInput.getText()
                appSocket.url = hostAddressTextInput.getText()
                appSocket.sendTextMessage(login + qsTr(" ") + password)*/

                var component = Qt.createComponent("configurationform.qml")
                var window = component.createObject(appWindow)
                window.show()
                appWindow.hide()
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

