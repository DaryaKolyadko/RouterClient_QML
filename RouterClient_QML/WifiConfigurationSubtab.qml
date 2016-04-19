import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ScrollView {
    id:wifiConfigurationId
    implicitWidth: 650
    implicitHeight: 200
    clip: true
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    property alias generalBackup: localBackup
    property alias innerContent: content
    property int bottomMargin: 15//resolution.dp(15)//15
    property int fontCoefficient: 100//resolution.dp(100)//100
    property string ssidStr: "Ssid"
    property string wifiStatusStr: "WifiStatus"
    property string frequencyRangeStr: "FrequencyRange"

    Item {
        id: content
        enabled: false
        width: Math.max(wifiConfigurationId.viewport.width, wifiConfigurationGridLayout.implicitWidth + 2 * wifiConfigurationGridLayout.rowSpacing)
        height: Math.max(wifiConfigurationId.viewport.height, wifiConfigurationGridLayout.implicitHeight + 2 * wifiConfigurationGridLayout.columnSpacing)

        Connections {
            target: socketcontroller
        }

        function checkAllParams() {
            return checkNewParamValue(ssidStr, localBackup.ssid, ssidTextInput.text) &&
                    checkNewParamValue(wifiStatusStr, localBackup.wifiStatus,
                                       wifiStatusList.get(wifiStatusComboBox.currentIndex).text) &&
                    checkNewParamValue(frequencyRangeStr, localBackup.frequencyRange,
                                       frequencyRangeListModel.get(frequencyRangeComboBox.currentIndex).text);
        }

        function setAllParams() {
            setNewParamValue(ssidStr, localBackup.ssid, ssidTextInput.text);
            setNewParamValue(wifiStatusStr, localBackup.wifiStatus,
                             wifiStatusList.get(wifiStatusComboBox.currentIndex).text);
            setNewParamValue(frequencyRangeStr, localBackup.frequencyRange,
                             frequencyRangeListModel.get(frequencyRangeComboBox.currentIndex).text);
        }

        function checkNewParamValue(paramName, paramValue, newParamValue)
        {
            var hasChanges = paramValue.localeCompare(newParamValue);
            if (hasChanges !== 0)
            {
                var res = socketcontroller.permitSetParamInfo(paramName, newParamValue);
                if(res === 1)
                    return true;
                else if (res === 0)
                    wifiConfigurationMessageDialog.show(qsTr("error_setting").arg(paramName).arg(newParamValue));
                else //new
                    wifiConfigurationErrorDialog.show(qsTr("connection_lost"));
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

        InfoMessageDialog {
            id: wifiConfigurationMessageDialog
        }

        ErrorInfoDialog {
            id: wifiConfigurationErrorDialog

            function doAction()
            {
                socketcontroller.logOutSignal();
            }
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

        GridLayout {
            id: wifiConfigurationGridLayout
            objectName: "wifiConfiguration"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: wifiConfigurationGridLayout.rowSpacing
            anchors.rightMargin: wifiConfigurationGridLayout.rowSpacing
            anchors.topMargin: wifiConfigurationGridLayout.columnSpacing
            clip: true
            columns: 3
            anchors.centerIn: parent
            Layout.fillWidth: true

            Text{
                id: ssidText
                font.letterSpacing: 1
                font.pointSize: (wifiConfigurationId.height + wifiConfigurationId.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("ssid")
            }

            TextField {
                id: ssidTextInput
                objectName: "ssidTextInput"
                font.letterSpacing: 1
                font.pointSize: (wifiConfigurationId.height + wifiConfigurationId.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                style: MyTextFieldStyle{id: ssidfield}
            }

            Text{
                id:frequencyRangeText
                font.letterSpacing: 1
                font.pointSize: (wifiConfigurationId.height + wifiConfigurationId.width)/fontCoefficient
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
                font.pointSize: (wifiConfigurationId.height + wifiConfigurationId.width)/fontCoefficient
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

        //possible values from server
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

        // translation
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
}
