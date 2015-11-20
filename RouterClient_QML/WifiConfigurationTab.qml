import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab{
    id: wifiConfogurationTabId
    active: true
    title: qsTr("Wi-Fi")

    property bool userEditingConfiguration: false
    property int bottomMargin: 15
    property int fontCoefficient: 100

    Connections {
        target: socketcontroller
    }

    GridLayout{
        id: wifiConfiguration
        columns: 3
        anchors.fill: parent

        InfoMessageDialog {
            id: wifiConfigurationMessageDialog
        }

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
                {
                    wifiConfigurationGridLayout.enabled = false
                    if(checkAndSetNewParamValue("Ssid", ssidTextInput.text) &&
                       checkAndSetNewParamValue("WifiStatus",
                                wifiStatusListModel.get(wifiStatusComboBox.currentIndex)) &&
                       checkAndSetNewParamValue("FrequencyRange",
                                frequencyRangeListModel.get(frequencyRangeComboBox .currentIndex))){
                       wifiConfigurationMessageDialog.show(qsTr("Все изменения сохранены."));
                    }
                    else return;
                }
                else
                    wifiConfigurationGridLayout.enabled = true;
                userEditingConfiguration = !userEditingConfiguration;
                //TODO
                // create backup to compare
            }

            function checkAndSetNewParamValue(paramName, paramValue)
            {
                var res = socketcontroller.setParamInfo(paramName, paramValue);
                if(res === 1)
                     return true;
                wifiConfigurationMessageDialog.show(qsTr("Проблема с установкой значения: "
                                                            + paramName + " = " + paramValue +
                                                            ". Проверьте введенные значения и исправьте ошибки."));
                return false;
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
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("Имя беспроводной сети (SSID):")
            }

            TextField {
                id: ssidTextInput
                objectName: "ssidTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                style: MyTextFieldStyle{id: ssidfield}
            }

            Text{
                id:frequencyRangeText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
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
                        duration: 1000
                    }
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
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
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
        objectName: "wifiStatusListModel"

        function addWifiStatus(wifiStatus)
        {
            append({text: wifiStatus})
        }
    }

    ListModel{
        id: frequencyRangeListModel
        objectName: "frequencyRangeListModel"

        function addFrequencyRange(frequencyRange)
        {
            append({text: frequencyRange + " Hz"})
        }
    }
}
}