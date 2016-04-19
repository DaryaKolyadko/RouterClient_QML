import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item {
    id: vlanSetupTabId

    Connections {
        target: socketcontroller
    }

    function redirectToFirstTab()
    {
        vlanTabView.currentIndex  = 0;
    }

    TabView{
        id: vlanTabView
        anchors.fill: parent

        Tab{
            id: vlanSubtabId
            objectName: "vlanTabId"
            active: true
            title: qsTr("vlan_subtab")

            property bool userEditingConfiguration: false
            property int bottomMargin: 15//resolution.dp(15) // 15
            property int topMargin: 50
            property string vlanSettingsStr: "VlanSettings"
            property string vlanTypeStr: "VlanType"
            property string portPvidStr: "PortPvid"
            property string portTaggingStatusStr: "PortTaggingStatus"
            property string portVlanStr: "PortVlan"
            property int fontCoefficient: 85
            property int portPvidId: -1
            property int portTaggingId: -2
            property bool init: false

            ColumnLayout{
                id: columnLayout
                Component.onCompleted: {
                    vlanTypeList.addVlanType("noVlan");
                    vlanTypeList.addVlanType("portBased");
                    vlanTypeList.addVlanType("802.1q");
                    vlanTypeListModel.addVlanType(qsTr("noVlan"));
                    vlanTypeListModel.addVlanType(qsTr("portBased"));
                    vlanTypeListModel.addVlanType(qsTr("802.1q"));
                }

                InfoMessageDialog {
                    id: vlanSetupMessageDialog
                }

                ErrorInfoDialog{
                    id: vlanSetupErrorDialog

                    function doAction()
                    {
                        socketcontroller.logOutSignal();
                    }
                }

                ColumnLayout{
                    id: columnLayoutId

                    RowLayout{
                        id: rowLayoutId
                        Layout.fillWidth: true
                        anchors.top: parent.top

                        Button{
                            id: changeConfiguration
                            text: userEditingConfiguration ? qsTr("save_settings") : qsTr("change_settings")
                            Layout.fillWidth: true

                            onClicked: {
                                if(userEditingConfiguration) {
                                    vlanSubtab.innerContent.enabled = false;

                                    if(vlanSubtab.possibleChangedItemIndexes.length == 0) {
                                        vlanSetupMessageDialog.show(qsTr("changes_saved"));
                                        userEditingConfiguration = !userEditingConfiguration;
                                        return;
                                    }

                                    var checkSuccess = true;
                                    var setSuccess = true;

                                    vlanSubtab.possibleChangedItemIndexes.forEach(function f(element,index,array)
                                    {
                                        if(checkSuccess)
                                        {
                                            var paramName = ""
                                            var oldValue = ""
                                            var newValue = ""

                                            if(element.vlan >= 0)
                                            {
                                                paramName = portVlanStr;
                                                oldValue = vlanSubtab.vlanBackup.portsAndVlans[element.port][element.vlan];
                                                newValue = vlanSubtab.vlanCurrent.portsAndVlans[element.port][element.vlan];
                                                checkSuccess = checkNewPortVlan(paramName, element.port, element.vlan, oldValue, newValue);

                                                if(!checkSuccess)
                                                    vlanSubtab.innerContent.enabled = true;

                                                return;
                                            }
                                            else if (element.vlan === portPvidId)
                                            {
                                                paramName = portPvidStr;
                                                oldValue = vlanSubtab.vlanBackup.portsPvid[element.port].toString();
                                                newValue = vlanSubtab.vlanCurrent.portsPvid[element.port].toString();
                                            }
                                            else if (element.vlan === portTaggingId)
                                            {
                                                paramName = portTaggingStatusStr;
                                                oldValue = vlanSubtab.vlanBackup.portsTagging[element.port];
                                                newValue = vlanSubtab.vlanCurrent.portsTagging[element.port];
                                            }

                                            checkSuccess = checkNewParamValue(paramName, element.port, oldValue, newValue);

                                            if(!checkSuccess)
                                                vlanSubtab.innerContent.enabled = true;
                                            return;
                                        }
                                    });


                                    if(checkSuccess)
                                    {
                                        vlanSubtab.possibleChangedItemIndexes.forEach(function f(element,index,array)
                                        {
                                            var paramName = ""
                                            var oldValue = ""
                                            var newValue = ""

                                            if(element.vlan >= 0)
                                            {
                                                paramName = portVlanStr;
                                                oldValue = vlanSubtab.vlanBackup.portsAndVlans[element.port][element.vlan];
                                                newValue = vlanSubtab.vlanCurrent.portsAndVlans[element.port][element.vlan];

                                                setSuccess = setNewPortVlan(element.port, element.vlan, oldValue, newValue);
                                                return;
                                            }
                                            else if (element.vlan === portPvidId)
                                            {
                                                paramName = portPvidStr;
                                                oldValue = vlanSubtab.vlanBackup.portsPvid[element.port].toString();
                                                newValue = vlanSubtab.vlanCurrent.portsPvid[element.port].toString();
                                            }
                                            else if (element.vlan === portTaggingId)
                                            {
                                                paramName = portTaggingStatusStr;
                                                oldValue = vlanSubtab.vlanBackup.portsTagging[element.port];
                                                newValue = vlanSubtab.vlanCurrent.portsTagging[element.port];
                                            }

                                            setSuccess = setNewParamValue(paramName, element.port, oldValue, newValue);
                                        });

                                        vlanSubtab.innerContent.enabled = false;
                                        vlanSubtab.possibleChangedItemIndexes = []

                                        if(setSuccess)
                                            vlanSetupMessageDialog.show(qsTr("changes_saved"));
                                    }
                                }
                                else {
                                    vlanSubtab.innerContent.enabled = true;
                                }
                                userEditingConfiguration = !userEditingConfiguration;
                            }

                            function checkNewParamValue(paramName, port, paramValue, newParamValue)
                            {
                                var hasChanges = paramValue.localeCompare(newParamValue);

                                if (hasChanges !== 0) {
                                    //var res = 1;
                                    var res = socketcontroller.permitSetParamInfo(paramName, (port+1) + " " + newParamValue);

                                    if(res === 1)
                                        return true;
                                    else if (res === 0)
                                        vlanSetupMessageDialog.show(qsTr("error_setting").arg(paramName).arg(newParamValue));
                                    else // new
                                        vlanSetupErrorDialog.show(qsTr("connection_lost"));
                                    return false;
                                }
                                return true;
                            }

                            function setNewParamValue(paramName, port, paramValue, newParamValue)
                            {
                                var hasChanges = paramValue.toString().localeCompare(newParamValue.toString());

                                if (hasChanges !== 0) {
                                    //var res = 1;
                                    var res = socketcontroller.setParamInfo(paramName, (port+1) + " " + newParamValue);
                                    if(res === 1) {
                                        vlanSubtab.vlanBackup.updateFieldByName(paramName, port, newParamValue);
                                        return true;
                                    }
                                    else if (res === 0)
                                        vlanSetupMessageDialog.show(qsTr("error_setting").arg(paramName).arg(newParamValue));
                                    else // new
                                        vlanSetupErrorDialog.show(qsTr("connection_lost"));
                                    return false;
                                }
                                return true;
                            }

                            function checkNewPortVlan(paramName, port, vlan, paramValue, newParamValue)
                            {
                                var hasChanges = paramValue !== newParamValue;

                                if (hasChanges == true) {
                                    //var res = 1;
                                    var res = socketcontroller.permitSetParamInfo(paramName, (port+1) + " " + (vlan+1) + " " + (newParamValue ? "On" : "Off"));

                                    if(res === 1)
                                        return true;
                                    else if (res === 0)
                                        vlanSetupMessageDialog.show(qsTr("error_setting").arg(paramName).arg(newParamValue));
                                    else // new
                                        vlanSetupErrorDialog.show(qsTr("connection_lost"));
                                    return false;
                                }
                                return true;
                            }

                            function setNewPortVlan(port, vlan, paramValue, newParamValue)
                            {
                                var hasChanges = paramValue !== newParamValue;

                                if (hasChanges == true) {
                                    var res = socketcontroller.setParamInfo(portVlanStr, (port+1) + " " + (vlan+1) + " " + (newParamValue ? "On" : "Off"));
                                    if(res === 1) {
                                        vlanSubtab.vlanBackup.updateField(port, vlan, newParamValue);
                                        return true;
                                    }
                                    else if (res === 0)
                                        vlanSetupMessageDialog.show(qsTr("error_setting").arg(paramName).arg(newParamValue));
                                    else // new
                                        vlanSetupErrorDialog.show(qsTr("connection_lost"));
                                    return false;
                                }
                                return true;
                            }
                        }

                        Button{
                            id: updateVlanSetupListButton
                            text: qsTr("update_vlan_setup_list")
                            Layout.fillWidth: true
                            onClicked: {
                                socketcontroller.getVlanSettings();
                            }
                        }
                    }

                    ComboBox{
                        id: vlanTypeCombobox
                        objectName: "vlanTypeCombobox"
                        model: vlanTypeListModel
                        Layout.fillWidth: true
                        property bool loading: true

                        onCurrentIndexChanged: {
                            var newValue = vlanTypeList.get(currentIndex).text;

                            if(!loading && !init) {
                                if (checkNewVlanType(newValue))
                                {
                                    setNewVlanType(newValue);
                                    socketcontroller.getVlanSettings();
                                }
                            }

                            vlanSubtab.innerContent.setVisible(newValue);
                        }

                        Component.onCompleted: {
                            loading = false;
                        }

                        function checkNewVlanType(newVlanType)
                        {
                            var res = socketcontroller.permitSetParamInfo(vlanTypeStr, newVlanType);

                            if(res === 1)
                                return true;
                            else if (res === 0)
                                vlanSetupMessageDialog.show(qsTr("error_setting").arg(vlanTypeStr).arg(newVlanType));
                            else // new
                                vlanSetupErrorDialog.show(qsTr("connection_lost"));
                            return false;
                        }

                        function setNewVlanType(newVlanType)
                        {
                            var res = socketcontroller.setParamInfo(vlanTypeStr, newVlanType);

                            if(res === 1)
                                return true;
                            else if (res === 0)
                                vlanSetupMessageDialog.show(qsTr("error_setting").arg(vlanTypeStr).arg(newVlanType));
                            else // new
                                vlanSetupErrorDialog.show(qsTr("connection_lost"));
                            return false;
                        }
                    }
                }

                ColumnLayout{
                    anchors.top: columnLayoutId.bottom
                    anchors.bottom: parent.bottom

                    VlanSetupSubtab{
                        id: vlanSubtab
                        objectName: "vlanSetupSubtab"
                        anchors.fill: parent
                        clip: true
                        Layout.fillWidth: true
                    }
                }

                //possible values from server
                ListModel{
                    id: vlanTypeList
                    objectName: "vlanTypeList"

                    function addVlanType(vlanType)
                    {
                        append({text: vlanType})
                    }

                    function getChild(index)
                    {
                        return get(index)
                    }
                }

                // translation
                ListModel{
                    id: vlanTypeListModel
                    objectName: "vlanTypeListModel"

                    function addVlanType(vlanType)
                    {
                        append({text: vlanType})
                    }

                    function getChild(index)
                    {
                        return get(index)
                    }
                }
            }
        }
    }
}
