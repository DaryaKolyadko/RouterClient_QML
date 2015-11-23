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
    property string networkMaskStr: "NetworkMask"
    property string hostAddressStr: "HostAddress"

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

        Item{
            id: localBackup
            objectName: "localBackup"
            property string hostAddress: ""
            property string networkMask: ""

            function updateFieild(fieldName, newFieldValue)
            {
                switch (fieldName)
                {
                case networkMaskStr:
                    networkMask = newFieldValue;
                    break;
                case hostAddressStr:
                    hostAddress = newFieldValue;
                    break;
                default:
                }
            }
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
                    if(checkNewParamValue(hostAddressStr, localBackup.hostAddress, hostAddressTextInput.text) &&
                            checkNewParamValue(networkMaskStr, localBackup.networkMask, networkMaskTextInput.text))
                    {
                        setNewParamValue(hostAddressStr, localBackup.hostAddress, hostAddressTextInput.text);
                        setNewParamValue(networkMaskStr, localBackup.networkMask, networkMaskTextInput.text);
                        generalConfigurationMessageDialog.show(qsTr("Все изменения сохранены."));
                    }
                    else return;
                }
                else
                {
                    mainConfigurationGridLayout.enabled = true;
                    macAddressTextInput.enabled = false;
                }
                userEditingConfiguration = !userEditingConfiguration;
            }

            function checkNewParamValue(paramName, paramValue, newParamValue)
            {
                var hasChanges = paramValue.localeCompare(newParamValue);
                if (hasChanges !== 0)
                {
                    var res = socketcontroller.permitSetParamInfo(paramName, newParamValue);
                    if(res === 1)                     
                        return true;
                    generalConfigurationMessageDialog.show(qsTr("Проблема с установкой значения: "
                                                                + paramName + " = " + newParamValue +
                                                                ". Проверьте введенные значения и исправьте ошибки."));
                    return false;
                }
                return true;
            }

            function setNewParamValue(paramName, paramValue, newParamValue)
            {
                var hasChanges = paramValue.localeCompare(newParamValue);
                if (hasChanges !== 0)
                {
                    var res = socketcontroller.setParamInfo(paramName, newParamValue);
                    if(res === 1)
                    {
                        localBackup.updateFieild(paramName, newParamValue);
                        return true;
                    }
                    return false;
                }
                return true;
            }
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
     //   }
     //   property alias general: generalConfigurationGridLayout

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
                text: qsTr("Адрес хоста:")
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
                text: qsTr("MAC-адрес: *")
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

            LimitedEditingText{
                id: limitedEditing
                Layout.columnSpan: 3
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient/2
                Layout.fillWidth: true
                anchors.bottomMargin: bottomMargin
            }
        }

//        function initBackupInner(){
//            localBackupId.networkMask = networkMaskTextInput.text;
//            localBackupId.hostAddress = hostAddressTextInput.text;
//            console.debug(localBackup.networkMask);
//            console.debug(localBackup.hostAddress);
//            //console.debug("i'm here");
//            //return networkMaskTextInput.text;
//        }
    }

//    function initBackup(){
//        general.initBackupInner();
//    }
//    function getNetworkMask(){
//        console.debug(networkMask);
//        return "lol";
//    }
}
