import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab{
    id: generalConfigurationTabId
    active: true
    title: qsTr("Основные настройки")
    property bool userEditingConfiguration: false
    property int bottomMargin: 15
    property int fontCoefficient: 100
    //property alias networkMask: hostAddressTextInput.text

    Connections {
        target: socketcontroller
    }


    GridLayout{
        id: generalConfigurationGridLayout
        columns: 3
        anchors.fill: parent

        InfoMessageDialog {
            id: generalConfigurationMessageDialog
        }

        Button{
            id: changeConfiguration
            text: userEditingConfiguration ? qsTr("Сохранить настройки") : qsTr("Изменить настройки")
            Layout.columnSpan: 3
            Layout.fillWidth: true
            anchors.bottomMargin: bottomMargin

            onClicked: {
                if(userEditingConfiguration)
                {
                    mainConfigurationGridLayout.enabled = false
                    if(checkAndSetNewParamValue("HostAddress", hostAddressTextInput.text) &&
                            checkAndSetNewParamValue("NetworkMask", networkMaskTextInput.text) &&
                            checkAndSetNewParamValue("MacAddress", macAddressTextInput.text)){
                       generalConfigurationMessageDialog.show(qsTr("Все изменения сохранены."));
                    }
                    else return;
                }
                else
                    mainConfigurationGridLayout.enabled = true;
                userEditingConfiguration = !userEditingConfiguration;
                //TODO
                // create backup to compare
            }

            function checkAndSetNewParamValue(paramName, paramValue)
            {
                var res = socketcontroller.setParamInfo(paramName, paramValue);
                if(res === 1)
                     return true;
                generalConfigurationMessageDialog.show(qsTr("Проблема с установкой значения: "
                                                            + paramName + " = " + paramValue +
                                                            ". Проверьте введенные значения и исправьте ошибки."));
                return false;
            }

//            onClicked: {
//                if(userEditingConfiguration)
//                {
//                    mainConfigurationGridLayout.enabled = false
//                    if(checkNewParamValue("hostAddress", hostAddressTextInput.text) &&
//                            checkNewParamValue("networkMask", networkMaskTextInput.text) &&
//                            checkNewParamValue("macAddress", macAddressTextInput.text))
//                    {
//                        socketcontroller.setParamInfo("hostAddress", hostAddressTextInput.text);
//                        socketcontroller.setParamInfo("networkMask", networkMaskTextInput.text);
//                        socketcontroller.setParamInfo("macAddress", macAddressTextInput.text);
//                    }
//                }
//                else
//                    mainConfigurationGridLayout.enabled = true;
//                userEditingConfiguration = !userEditingConfiguration;
//                //TODO
//                // create backup to compare
//            }

//            function checkNewParamValue(paramName, paramValue)
//            {
//                var res = socketcontroller.permitSetParamInfo(paramName, paramValue);
//                if(res === 0) // 1)
//                    return true;
//                generalConfigurationMessageDialog.show(qsTr("Проблема с установкой значения: "
//                                                            + paramName + " = " + paramValue));
//                return false;
//            }
        }

        GridLayout {
            id: mainConfigurationGridLayout
            columns: 3
            anchors.centerIn: parent
            enabled: false
            Layout.fillWidth: true

//            function getNetworkMaskInner(){
//                console.debug("i'm here");
//                return networkMaskTextInput.text;
//            }

            Text{
                id: hostAddressText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                anchors.bottomMargin: bottomMargin
                text: qsTr("Адрес хоста:" + bottomMargin.toString())
            }

            TextField {
                id: hostAddressTextInput
                objectName: "hostAddressTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                style: MyTextFieldStyle{id: hostaddrfield}
                anchors.bottomMargin: bottomMargin
                text: "192.168.56.101"
                validator: RegExpValidator{
                    regExp: /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
                }
            }

            Text{
                id: networkMaskText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                anchors.bottomMargin: bottomMargin
                text: qsTr("Маска подсети:")
            }

            TextField {
                id:networkMaskTextInput
                objectName: "networkMaskTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                anchors.bottomMargin: bottomMargin
                style: MyTextFieldStyle{id: networkmaskfield}
                validator: RegExpValidator{
                    regExp: /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
                }
            }

            Text{
                id: macAddressText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                anchors.bottomMargin: bottomMargin
                text: qsTr("MAC-адрес:")
            }

            TextField {
                id:macAddressTextInput
                objectName: "macAddressTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                anchors.bottomMargin: bottomMargin
                style: MyTextFieldStyle{id: macaddrefield}
                validator: RegExpValidator{
                    regExp: /\b(^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$)\b/
                }
            }
        }
    }

//    function getNetworkMask(){
//        console.debug(networkMask);
//        return "lol";
//    }
}
