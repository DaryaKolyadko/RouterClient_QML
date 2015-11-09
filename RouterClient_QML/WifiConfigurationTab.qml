import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab{
    id: wifiConfogurationTabId
    title: qsTr("Wi-Fi")

    property bool userEditingConfiguration: false
    property int bottomMargin: -1
    property int fontCoefficient: -1

    Connections {
        target: socketworker
    }

    GridLayout{
        id: wifiConfiguration
        objectName: "wifiConfiguration"
        columns: 3
        anchors.fill: parent

        Component.onCompleted: {
            //TODO from server
            wifiStatusListModel.addWifiStatus("Выключена");
            wifiStatusListModel.addWifiStatus("Включена");
            frequencyRangeListModel.addFrequencyRange("2.4");
            frequencyRangeListModel.addFrequencyRange("5.0");
        }

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
                // TODO set params on click
            }
        }

        GridLayout {
            id: wifiConfigurationGridLayout
            objectName: "wifiConfigurationGridLayout"
            columns: 3
            anchors.centerIn: parent
            enabled: false
            Layout.fillWidth: true

            Text{
                id: ssid
                font.letterSpacing: 1
                font.pointSize: (parent.height + parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("Имя беспроводной сети (SSID):")
            }

            TextField {
                id: ssidTextInput
                objectName: "ssidTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.height + parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                style: MyTextFieldStyle{id: ssidfield}
            }

            Text{
                id:frequencyRangeText
                font.letterSpacing: 1
                font.pointSize: (parent.height + parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("Частотный диапазон:")
            }

            ComboBox {
                id:frequencyRangeComboBox
                Layout.columnSpan: 2
                Layout.fillWidth: true
                model: frequencyRangeListModel
                        transitions: Transition {
                                        NumberAnimation {
                                            properties: "height";
                                            easing.type: Easing.OutExpo;
                                            duration: 1000 }
                                    }
                }

//                    Combobox{
//                        id: ff
//                        Layout.columnSpan: 2
//                        Layout.fillWidth: true
//                        anchors.bottomMargin: 20
//                        anchors.topMargin: 0
//                    }

            Text{
                id:wifiStatusText
                font.letterSpacing: 1
                font.pointSize: (parent.height + parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("Точка доступа Wi-Fi:")
            }

            ComboBox {
                id:wifiStatusComboBox
                Layout.columnSpan: 2
                Layout.fillWidth: true
                model: wifiStatusListModel
                transitions: Transition {
                                        NumberAnimation {
                                            properties: "height";
                                            easing.type: Easing.OutExpo;
                                            duration: 1000 }
                                    }
                }
//                    Combobox{
//                        id: wf
//                        Layout.columnSpan: 2
//                        Layout.fillWidth: true
//                        anchors.topMargin: 0
//                        z: 900
//                    }
//        }
//        }

}
    ListModel{
        id: wifiStatusListModel

        function addWifiStatus(wifiStatus)
        {
            append({text: wifiStatus})
        }
    }

    ListModel{
        id: frequencyRangeListModel

        function addFrequencyRange(frequencyRange)
        {
            append({text: frequencyRange + " Hz"})
        }
    }
}
}
