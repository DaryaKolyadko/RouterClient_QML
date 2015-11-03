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

    Component.onCompleted: {
        frequencyRangeListModel.append({hz: 2.4})
        frequencyRangeListModel.append({hz: 5.0})
        console.debug("lalka")
    }

    property int bottomMargin: 15
    property int fontСoefficient: 115

    TabView{
        id: tabView
        anchors.fill: parent

        Tab{
            id: generalConfigurationTab
            anchors.fill: parent
            title: qsTr("Основные настройки")

            property bool userEditingConfiguration: false

            GridLayout{
                id: configurationColumnLayout
                columns: 3
                anchors.fill: parent

                Button{
                    id: changeConfiguration
                    text: userEditingConfiguration ? qsTr("Сохранить настройки") : qsTr("Изменить настройки")
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    //Layout.width: gridLayoutMainConfig.width
                    anchors.bottomMargin: bottomMargin

                    onClicked: {
                        if(userEditingConfiguration)
                            gridLayoutMainConfig.enabled = false
                        else
                            gridLayoutMainConfig.enabled = true
                        userEditingConfiguration = !userEditingConfiguration
                    }
                }

                GridLayout {
                    id: gridLayoutMainConfig
                    columns: 3
                    anchors.centerIn: parent
                    enabled: false
                    Layout.fillWidth: true

                    Text{
                        id: hostAddressText
                        font.letterSpacing: 1
                        font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                        Layout.fillWidth: true
                        anchors.bottomMargin: bottomMargin
                        text: qsTr("Адрес хоста:")
                    }

                    TextField {
                        id: hostAddressTextInput
                        font.letterSpacing: 1
                        font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        style: textFieldStyle
                        anchors.bottomMargin: bottomMargin
                        validator: RegExpValidator{
                            regExp: /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
                        }
                    }

                    Text{
                        id: networkMaskText
                        font.letterSpacing: 1
                        font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                        Layout.fillWidth: true
                        anchors.bottomMargin: bottomMargin
                        text: qsTr("Маска подсети:")
                    }

                    TextField {
                        id:networkMaskTextInput
                        font.letterSpacing: 1
                        font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        anchors.bottomMargin: bottomMargin
                        style: textFieldStyle
                        validator: RegExpValidator{
                            regExp: /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
                        }
                    }

                    Text{
                        id: macAddressText
                        font.letterSpacing: 1
                        font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                        Layout.fillWidth: true
                        anchors.bottomMargin: bottomMargin
                        text: qsTr("MAC-адрес:")
                    }

                    TextField {
                        id:macAddressTextInput
                        font.letterSpacing: 1
                        font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        anchors.bottomMargin: bottomMargin
                        style: textFieldStyle
                        validator: RegExpValidator{
                            regExp: /\b(^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$)\b/
                        }
                    }
                }
            }
        }

        Tab{
            id: wifiConfiguration
            title: qsTr("Wi-Fi")

            GridLayout {
                id: gridLayoutWifiConfig
                columns: 3
                anchors.centerIn: parent
               // width: appWindowMain.width*2/3

                Text{
                    id: ssid
                    font.letterSpacing: 1
                    font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                    Layout.fillWidth: true
                    text: qsTr("Имя беспроводной сети (SSID):")
                }

                TextField {
                    id: ssidTextInput
                    font.letterSpacing: 1
                    font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    style: textFieldStyle
                }

                Text{
                    id:frequencyRangeText
                    font.letterSpacing: 1
                    font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                    Layout.fillWidth: true
                    text: qsTr("Частотный диапазон:")
                }

                TextField {
                    id:frequencyRangeTextInput
                    font.letterSpacing: 1
                    font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    style: textFieldStyle
                    validator: RegExpValidator{
                        regExp: /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
                    }
                }
/*
                Text{
                    id: macAddressText
                    font.bold: true
                    font.letterSpacing: 1
                    font.pointSize: (appWindow.height + appWindow.width)/fontCoefficient
                    Layout.fillWidth: true
                    text: qsTr("MAC-адрес:")
                }

                TextField {
                    id:macAddressTextInput
                    font.letterSpacing: 1
                    font.pointSize: (appWindow.height + appWindow.width)/fontCoefficient
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    style: textFieldStyle
                    enabled: false
                    validator: RegExpValidator{
                        regExp: /\b(^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$)\b/
                    }
                }*/
            }
        }
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

        ListModel {
            id: frequencyRangeListModel
        }

        statusBar: StatusBar {
            RowLayout {
                anchors.fill: parent
                Label {
                    text: "There will be a login"
                    Layout.alignment: Qt.AlignLeft
                }
                Button{
                    text: qsTr("Выйти")
                    Layout.alignment: Qt.AlignRight
                    onClicked: {
                        var component = Qt.createComponent("main.qml")
                        var window = component.createObject(appWindowMain)
                        window.show()
                        appWindowMain.hide()
                    }
                    }
                }
            }
}
