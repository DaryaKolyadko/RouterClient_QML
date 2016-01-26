import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab{
    id: wifiConfogurationTabId
    active: true
    title: qsTr("wifi")

    property bool userEditingConfiguration: false
    property int bottomMargin: 15//resolution.dp(15)//15
    property int fontCoefficient: 100//resolution.dp(100)//100
    property string ssidStr: "Ssid"
    property string wifiStatusStr: "WifiStatus"
    property string frequencyRangeStr: "FrequencyRange"

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
            wifiStatusListModel.addWifiStatus(qsTr("on"));
            wifiStatusListModel.addWifiStatus(qsTr("off"));
            wifiStatusList.addWifiStatus("On");
            wifiStatusList.addWifiStatus("Off");
            frequencyRangeListModel.addFrequencyRange("2.4");
            frequencyRangeListModel.addFrequencyRange("5.0");
        }

        Item{
            id: localBackup
            objectName: "localBackup"
            property string ssid: ""
            property string frequencyRange: ""
            property string wifiStatus: ""

            function updateField(fieldName, newFieldValue)
            {
                switch (fieldName) {
                case ssidStr:
                    ssid = newFieldValue;
                    break;
                case frequencyRangeStr:
                    frequencyRange = newFieldValue;
                    break;
                case wifiStatusStr:
                    wifiStatus = newFieldValue;
                    break;
                default:
                }
            }
        }

        Button{
            id: changeWifiConfiguration
            text: userEditingConfiguration ? qsTr("save_settings") : qsTr("change_settings")
            Layout.columnSpan: 3
            Layout.fillWidth: true
            anchors.bottomMargin: bottomMargin
            onClicked: {
                if(userEditingConfiguration) {
                    wifiConfigurationGridLayout.enabled = false;
                    if(checkNewParamValue(ssidStr, localBackup.ssid, ssidTextInput.text) &&
                       checkNewParamValue(wifiStatusStr, localBackup.wifiStatus,
                                wifiStatusList.get(wifiStatusComboBox.currentIndex).text) &&
                       checkNewParamValue(frequencyRangeStr, localBackup.frequencyRange,
                                frequencyRangeListModel.get(frequencyRangeComboBox.currentIndex).text))
                    {
                        setNewParamValue(ssidStr, localBackup.ssid, ssidTextInput.text);
                        setNewParamValue(wifiStatusStr, localBackup.wifiStatus,
                                         wifiStatusList.get(wifiStatusComboBox.currentIndex).text);
                        setNewParamValue(frequencyRangeStr, localBackup.frequencyRange,
                                         frequencyRangeListModel.get(frequencyRangeComboBox.currentIndex).text);
                        wifiConfigurationMessageDialog.show(qsTr("changes_saved"));
                    }
                    else {
                        wifiConfigurationGridLayout.enabled = true;
                        return;
                    }
                }
                else
                    wifiConfigurationGridLayout.enabled = true;
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
                    wifiConfigurationMessageDialog.show(qsTr("error_setting").arg(paramName).arg(newParamValue));
                    return false;
                }
                return true;
            }

            function setNewParamValue(paramName, paramValue, newParamValue)
            {
                var hasChanges = paramValue.localeCompare(newParamValue);
                if (hasChanges !== 0) {
                    var res = socketcontroller.setParamInfo(paramName, newParamValue);
                    if(res === 1)
                    {
                        localBackup.updateField(paramName, newParamValue);
                        return true;
                    }
                    return false;
                }
                return true;
            }
        }

        GridLayout {
            id: wifiConfigurationGridLayout
            columns: 3
            anchors.centerIn: parent
            enabled: false
            Layout.fillWidth: true

            Text{
                id: ssidText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("ssid")
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
                text: qsTr("frequency_range")
            }

            ComboBox {
                id:frequencyRangeComboBox
                objectName: "frequencyRangeComboBox"
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

            Text{
                id:wifiStatusText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("wap")
            }

            ComboBox {
                id:wifiStatusComboBox
                objectName: "wifiStatusComboBox"
                Layout.columnSpan: 2
                Layout.fillWidth: true
                model: wifiStatusListModel
                transitions: Transition {
                            NumberAnimation {
                                properties: "height";
                                easing.type: Easing.OutExpo;
                                duration: 1000
                            }
                }
            }
}

    ListModel{
        id: wifiStatusListModel
        objectName: "wifiStatusListModel"

        function addWifiStatus(wifiStatus)
        {
            append({text: wifiStatus})
        }

        function getChild(index)
        {
            return get(index)
        }
    }

    ListModel{
        id: wifiStatusList
        objectName: "wifiStatusList"

        function addWifiStatus(wifiStatus)
        {
            append({text: wifiStatus})
        }

        function getChild(index)
        {
            return get(index)
        }
    }

    ListModel{
        id: frequencyRangeListModel
        objectName: "frequencyRangeListModel"

        function addFrequencyRange(frequencyRange)
        {
            append({text: frequencyRange})
        }

        function getChild(index)
        {
            return get(index)
        }
    }
}
//    ResolutionController{
//        id: resolution
//    }
}
