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
        frequencyRangeListModel.append({text: "2.4 Hz"})
        frequencyRangeListModel.append({text: "5.0 Hz"})
        wifiStatusListModel.append({text: "Выключена"})
        wifiStatusListModel.append({text: "Включена"})
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
                id: mainConfiguration
                columns: 3
                anchors.fill: parent

                Button{
                    id: changeConfiguration
                    text: userEditingConfiguration ? qsTr("Сохранить настройки") : qsTr("Изменить настройки")
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    anchors.bottomMargin: bottomMargin

                    onClicked: {
                        if(userEditingConfiguration)
                            mainConfigurationGridLayout.enabled = false
                        else
                            mainConfigurationGridLayout.enabled = true
                        userEditingConfiguration = !userEditingConfiguration
                    }
                }

                GridLayout {
                    id: mainConfigurationGridLayout
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
            id: wifiConfigurationTab
            title: qsTr("Wi-Fi")
            anchors.fill: parent

            property bool userEditingConfiguration: false

            GridLayout{
                id: wifiConfiguration
                columns: 3
                anchors.fill: parent

                Button{
                    id: changeWifiConfiguration
                    text: userEditingConfiguration ? qsTr("Сохранить настройки") : qsTr("Изменить настройки")
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    anchors.bottomMargin: bottomMargin

                    onClicked: {
                        if(userEditingConfiguration)
                            wifiConfigurationGridLayout.enabled = false
                        else
                            wifiConfigurationGridLayout.enabled = true
                        userEditingConfiguration = !userEditingConfiguration
                    }
                }

                GridLayout {
                    id: wifiConfigurationGridLayout
                    columns: 3
                    anchors.centerIn: parent
                    enabled: false
                    Layout.fillWidth: true

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

                    ComboBox {
                        id:frequencyRangeComboBox
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        model: frequencyRangeListModel
                        }

                    Text{
                        id:wifiStatusText
                        font.letterSpacing: 1
                        font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                        Layout.fillWidth: true
                        text: qsTr("Точка доступа Wi-Fi:")
                    }

                    ComboBox {
                        id:wifiStatusComboBox
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        model: wifiStatusListModel
                        }
                    }
                }
        }

        Tab{
            id: systemInformationTab
            title: qsTr("Информация о системе")
            anchors.fill: parent

            property bool userEditingConfiguration: false

            GridLayout{
                id: systemInformation
                columns: 3
                anchors.fill: parent

                Button{
                    id: changeSystemInformation
                    text: userEditingConfiguration ? qsTr("Сохранить настройки") : qsTr("Изменить настройки")
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    anchors.bottomMargin: bottomMargin

                    onClicked: {
                        if(userEditingConfiguration)
                            systemInformationGridLayout.enabled = false
                        else
                            systemInformationGridLayout.enabled = true
                        userEditingConfiguration = !userEditingConfiguration
                    }
                }

                GridLayout {
                    id: systemInformationGridLayout
                    columns: 3
                    anchors.centerIn: parent
                    enabled: false
                    Layout.fillWidth: true

                    Text{
                        id: model
                        font.letterSpacing: 1
                        font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                        Layout.fillWidth: true
                        text: qsTr("Модель:")
                    }

                    TextField {
                        id: modelTextInput
                        font.letterSpacing: 1
                        font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        text: qsTr("Keenetic Ultra")
                        style: textFieldStyle
                    }

                    Text{
                        id:serviceCodeRangeText
                        font.letterSpacing: 1
                        font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                        Layout.fillWidth: true
                        text: qsTr("Сервисный код:")
                    }

                    TextField {
                        id: serviceCodeTextInput
                        font.letterSpacing: 1
                        font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        text: qsTr("607-066-405-847-030")
                        style: textFieldStyle
                        validator: RegExpValidator{
                            regExp: /\b(?:(?:[0-9][0-9][0-9]?)-){3}(?:[0-9][0-9][0-9]?)\b/
                        }
                    }

                    Text{
                        id:hostNameStatusText
                        font.letterSpacing: 1
                        font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                        Layout.fillWidth: true
                        text: qsTr("Имя хоста:")
                    }

                    TextField {
                        id: hostNameTextInput
                        font.letterSpacing: 1
                        font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        text: qsTr("Keenetic_Ultra")
                        style: textFieldStyle
                    }

                    Text{
                        id: workGroupStatusText
                        font.letterSpacing: 1
                        font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                        Layout.fillWidth: true
                        text: qsTr("Рабочая группа:")
                    }

                    TextField {
                        id: workGroupTextInput
                        font.letterSpacing: 1
                        font.pointSize: (appWindowMain.height + appWindowMain.width)/fontСoefficient
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        text: qsTr("Home_1a-6")
                        style: textFieldStyle
                    }
                }
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

        ListModel {
            id: frequencyRangeListModel
        }

        ListModel{
            id: wifiStatusListModel
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
