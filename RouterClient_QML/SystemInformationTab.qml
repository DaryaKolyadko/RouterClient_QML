import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab{
    id: systemInformationTabId
    active: true
    title: qsTr("system_information")

    property bool userEditingConfiguration: false
    property int bottomMargin: 15//resolution.dp(15) //15
    property int fontCoefficient: 100//resolution.dp(100) // 100
    property string hostNameStr: "HostName"
    property string workGroupStr: "WorkGroup"

    Connections {
        target: socketcontroller
    }

    GridLayout{
        id: systemInformation
        columns: 3
        anchors.fill: parent

        InfoMessageDialog {
            id: systemConfigurationMessageDialog
        }

        Item{
            id: localBackup
            objectName: "localBackup"
            property string hostName: ""
            property string workGroup: ""

            function updateFieild(fieldName, newFieldValue)
            {
                switch (fieldName)
                {
                case hostNameStr:
                    hostName = newFieldValue;
                    break;
                case workGroupStr:
                    workGroup = newFieldValue;
                    break;
                default:
                }
            }
        }

        Button{
            id: changeSystemInformation
            text: userEditingConfiguration ? qsTr("save_settings") : qsTr("change_settings")
            Layout.columnSpan: 3
            Layout.fillWidth: true
            anchors.bottomMargin: bottomMargin

            onClicked: {
                if(userEditingConfiguration) {
                    systemInformationGridLayout.enabled = false
                    if(checkNewParamValue(hostNameStr, localBackup.hostName, hostNameTextInput.text) &&
                            checkNewParamValue(workGroupStr, localBackup.workGroup, workGroupTextInput.text))
                    {
                        setNewParamValue(hostNameStr, localBackup.hostName, hostNameTextInput.text);
                        setNewParamValue(workGroupStr, localBackup.workGroup, workGroupTextInput.text);
                        systemConfigurationMessageDialog.show(qsTr("changes_saved"));
                    }
                    else return;
                }
                else {
                    systemInformationGridLayout.enabled = true;
                    modelTextInput.enabled = false;
                    serviceCodeTextInput.enabled = false;
                }
                userEditingConfiguration = !userEditingConfiguration;
            }

            function checkNewParamValue(paramName, paramValue, newParamValue)
            {
                var hasChanges = paramValue.localeCompare(newParamValue);
                if (hasChanges !== 0) {
                    var res = socketcontroller.permitSetParamInfo(paramName, newParamValue);
                    if(res === 1)
                        return true;
                    systemConfigurationMessageDialog.show(qsTr("error_setting").arg(paramName).arg(newParamValue));
                    return false;
                }
                return true;
            }

            function setNewParamValue(paramName, paramValue, newParamValue)
            {
                var hasChanges = paramValue.localeCompare(newParamValue);
                if (hasChanges !== 0) {
                    var res = socketcontroller.setParamInfo(paramName, newParamValue);
                    if(res === 1) {
                        localBackup.updateFieild(paramName, newParamValue);
                        return true;
                    }
                    return false;
                }
                return true;
            }
        }

        GridLayout {
            id: systemInformationGridLayout
            columns: 3
            anchors.centerIn: parent
            enabled: false
            Layout.fillWidth: true

            Text{
                id: modelText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("model")
            }

            TextField {
                id: modelTextInput
                objectName: "modelTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                style: MyTextFieldStyle{id: modelfield}
            }

            Text{
                id:serviceCodeText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("service_code")
            }

            TextField {
                id: serviceCodeTextInput
                objectName: "serviceCodeTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                style: MyTextFieldStyle{id: servicecodefield}
                validator: RegExpValidator{
                    regExp: /\b(?:(?:[0-9][0-9][0-9]?)-){3}(?:[0-9][0-9][0-9]?)\b/
                }
            }

            Text{
                id:hostNameText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("host_name")
            }

            TextField {
                id: hostNameTextInput
                objectName: "hostNameTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                style: MyTextFieldStyle{id: hostnamefield}
            }

            Text{
                id: workGroupStatusText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("work_group")
            }

            TextField {
                id: workGroupTextInput
                objectName: "workGroupTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                style: MyTextFieldStyle{id: workgroupfield}
            }

            LimitedEditingText{
                id: limitedEditing
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient/2
                Layout.fillWidth: true
                Layout.columnSpan: 3
                anchors.bottomMargin: bottomMargin
            }
        }
    }

//    ResolutionController{
//        id: resolution
//    }
}
