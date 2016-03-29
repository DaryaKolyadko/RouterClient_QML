import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab {
    id: portTrunkSetupSubtabId
    active: true
    title: qsTr("port_trunk_setup")

    property bool userEditingConfiguration: false
    property int fontCoefficient: 100//resolution.dp(100)//100
    property string portTrunkStatusStr: "PortTrunkStatus"

    Connections {
        target: socketcontroller
    }

    GridLayout{
        id: portTrunkGrid
        columns: 3
        anchors.fill: parent

        InfoMessageDialog {
            id: portTrunkSetupMessageDialog
        }

        ErrorInfoDialog {
            id: portTrunkSetupErrorDialog

            function doAction()
            {
                socketcontroller.logOutSignal();
            }
        }

        Component.onCompleted: {
            portTrunkStatusListModel.addPortTrunkStatus(qsTr("enable"));
            portTrunkStatusListModel.addPortTrunkStatus(qsTr("disable"));
            portTrunkStatusList.addPortTrunkStatus("On");
            portTrunkStatusList.addPortTrunkStatus("Off");
        }

        Item{
            id: localBackup
            objectName: "localBackup"
            property string portTrunkStatus: ""

            function updateField(fieldName, newFieldValue)
            {
                switch (fieldName) {
                case portTrunkStatusStr:
                    portTrunkStatus = newFieldValue;
                    break;
                default:
                }
            }
        }

        Button{
            id: changeportTrunkStatus
            text: userEditingConfiguration ? qsTr("save_settings") : qsTr("change_settings")
            Layout.columnSpan: 3
            Layout.fillWidth: true
            anchors.bottomMargin: bottomMargin
            onClicked: {
                if(userEditingConfiguration) {
                    portTrunkGridLayout.enabled = false;
                    if(checkNewParamValue(portTrunkStatusStr, localBackup.portTrunkStatus,
                                          portTrunkStatusList.get(portTrunkStatusComboBox.currentIndex).text))
                    {
                        setNewParamValue(portTrunkStatusStr, localBackup.portTrunkStatus,
                                         portTrunkStatusList.get(portTrunkStatusComboBox.currentIndex).text);
                        portTrunkSetupMessageDialog.show(qsTr("changes_saved"));
                    }
                    else {
                        portTrunkGridLayout.enabled = true;
                        return;
                    }
                }
                else
                    portTrunkGridLayout.enabled = true;
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
                    else if (res === 0)
                        portTrunkSetupMessageDialog.show(qsTr("error_setting").arg(paramName).arg(newParamValue));
                    else //new
                        portTrunkSetupErrorDialog.show(qsTr("connection_lost"));
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
                    else //new
                        portTrunkSetupErrorDialog.show(qsTr("connection_lost"));
                    return false;
                }
                return true;
            }
        }

        GridLayout {
            id: portTrunkGridLayout
            columns: 3
            anchors.centerIn: parent
            enabled: false
            Layout.fillWidth: true

            Text{
                id: portTrunkStatusText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("port_trunk_7_8")
            }

            ComboBox {
                id:portTrunkStatusComboBox
                objectName: "portTrunkStatusComboBox"
                Layout.columnSpan: 2
                Layout.fillWidth: true
                model: portTrunkStatusListModel
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
            id: portTrunkStatusList
            objectName: "portTrunkStatusList"

            function addPortTrunkStatus(portTrunk)
            {
                append({text: portTrunk})
            }

            function getChild(index)
            {
                return get(index)
            }
        }

        ListModel{
            id: portTrunkStatusListModel
            objectName: "portTrunkStatusListModel"

            function addPortTrunkStatus(portTrunk)
            {
                append({text: portTrunk})
            }

            function getChild(index)
            {
                return get(index)
            }
        }
    }
}
