import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab{
    id: portSetupSubtabId
    active: true
    title: qsTr("port_setup")
    property bool userEditingConfiguration: false
    property int bottomMargin: 15//resolution.dp(15) // 15
    property int topMargin: 50
    property string setupModeStr: "SetupMode"
    property string setupFlowControlStr: "SetupFlowControl"
    property string setup802Str: "Setup802"
    property string setupPortPriorityStr: "SetupPortPriority"
    property string setupPortDescriptionStr: "SetupPortDescription"
    property int fontCoefficient: 85

    Connections {
        target: socketcontroller
    }

    ColumnLayout{
        id: columnLayout
        anchors.fill: parent

        InfoMessageDialog {
            id: generalConfigurationMessageDialog
        }

        ErrorInfoDialog{
            id: generalConfiguraionErrorDialog

            function doAction()
            {
                socketcontroller.logOutSignal();
            }
        }

        RowLayout{
            id: rowLayoutId
            anchors.bottomMargin: bottomMargin

            Button{
                id: changeConfiguration
                text: userEditingConfiguration ? qsTr("save_settings") : qsTr("change_settings")
                Layout.fillWidth: true
                anchors.bottomMargin: bottomMargin

                onClicked: {
                    if(userEditingConfiguration) {
                        portSetupSubtab.innerContent.enabled = false;

                        if(portSetupSubtab.possibleChangedItemIndexes.length == 0) {
                            generalConfigurationMessageDialog.show(qsTr("changes_saved"));
                            return;
                        }

                        portSetupSubtab.possibleChangedItemIndexes.forEach(function f(element,index,array)
                        {
                            if(checkNewParamValue(setupModeStr, element, portSetupSubtab.backup.setupMode[element],
                                                  portSetupSubtab._modeList.get(portSetupSubtab._portSetupModel.get(element).mode_idx).text) &&
                                    checkNewParamValue(setupFlowControlStr, element, portSetupSubtab.backup.setupFlowControl[element],
                                                       portSetupSubtab._flowControlList.get(portSetupSubtab._portSetupModel.get(element).flow_control_idx).text) &&
                                    checkNewParamValue(setup802Str, element, portSetupSubtab.backup.setup802[element],
                                                       portSetupSubtab._priority802List.get(portSetupSubtab._portSetupModel.get(element).priority802_idx).text) &&
                                    checkNewParamValue(setupPortPriorityStr, element, portSetupSubtab.backup.setupPortPriority[element],
                                                       portSetupSubtab._portBasePriorityList.get(portSetupSubtab._portSetupModel.get(element).port_base_priority_idx).text) &&
                                    checkNewParamValue(setupPortDescriptionStr, element, portSetupSubtab.backup.setupPortDescription[element],
                                                       portSetupSubtab._portSetupModel.get(element).port_description))
                            {
                                setNewParamValue(setupModeStr, element, portSetupSubtab.backup.setupMode[element],
                                                 portSetupSubtab._modeList.get(portSetupSubtab._portSetupModel.get(element).mode_idx).text);
                                setNewParamValue(setupFlowControlStr, element, portSetupSubtab.backup.setupFlowControl[element],
                                                 portSetupSubtab._flowControlList.get(portSetupSubtab._portSetupModel.get(element).flow_control_idx).text);
                                setNewParamValue(setup802Str, element, portSetupSubtab.backup.setup802[element],
                                                 portSetupSubtab._priority802List.get(portSetupSubtab._portSetupModel.get(element).priority802_idx).text);
                                setNewParamValue(setupPortPriorityStr, element, portSetupSubtab.backup.setupPortPriority[element],
                                                 portSetupSubtab._portBasePriorityList.get(portSetupSubtab._portSetupModel.get(element).port_base_priority_idx).text);
                                setNewParamValue(setupPortDescriptionStr, element, portSetupSubtab.backup.setupPortDescription[element],
                                                 portSetupSubtab._portSetupModel.get(element).port_description);
                                portSetupSubtab.possibleChangedItemIndexes = []
                                generalConfigurationMessageDialog.show(qsTr("changes_saved"));
                            }
                            else {
                                portSetupSubtab.innerContent.enabled = true;
                                return;
                            }
                        });
                    }
                    else {
                        portSetupSubtab.innerContent.enabled = true;
                    }
                    userEditingConfiguration = !userEditingConfiguration;
                }

                function checkNewParamValue(paramName, index, paramValue, newParamValue)
                {
                    var hasChanges = paramValue.localeCompare(newParamValue);
                    if (hasChanges !== 0) {
                        var res = socketcontroller.permitSetParamInfo(paramName,
                                                                      portSetupSubtab._portSetupModel.getChild(index).port + " " + newParamValue);
                        if(res === 1)
                            return true;
                        else if (res === 0)
                            generalConfigurationMessageDialog.show(qsTr("error_setting").arg(paramName).arg(newParamValue));
                        else // new
                            generalConfiguraionErrorDialog.show(qsTr("connection_lost"));
                        return false;
                    }
                    return true;
                }

                function setNewParamValue(paramName, index, paramValue, newParamValue)
                {
                    var hasChanges = paramValue.localeCompare(newParamValue);
                    if (hasChanges !== 0) {
                        var res = socketcontroller.setParamInfo(paramName,
                                                                portSetupSubtab._portSetupModel.get(index).port + " " + newParamValue);
                        if(res === 1) {
                            portSetupSubtab.backup.updateField(paramName, index, newParamValue);
                            return true;
                        }
                        return false;
                    }
                    return true;
                }
            }

            Button{
                id: updatePortSetupListButton
                text: qsTr("update_port_setup_list")
                Layout.fillWidth: true
                onClicked: {
                    socketcontroller.getPortSetupList();
                }
            }
        }

        ColumnLayout{
            anchors.top: rowLayoutId.bottom
            anchors.bottom: parent.bottom

            PortSetupSubtab{
                id: portSetupSubtab
                objectName: "portSetupSubtab"
                anchors.fill: parent
                clip: true
                Layout.fillWidth: true
            }
        }
    }
}
