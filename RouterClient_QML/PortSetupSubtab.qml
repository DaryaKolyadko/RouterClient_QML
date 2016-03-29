import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab {
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
    property var possibleChangedItemsIndexes: []

    function addPossibleChangeIndex(index)
    {
        if(possibleChangedItemsIndexes.indexOf(index) != -1)
            return;

        possibleChangedItemsIndexes.push(index);
    }

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

        Item{
            id: localBackup
            objectName: "localBackup"
            property var setupMode: []
            property var setupFlowControl: []
            property var setup802: []
            property var setupPortPriority: []
            property var setupPortDescription: []

            function updateField(fieldName, index, newFieldValue)
            {
                switch (fieldName) {
                case setupModeStr:
                    setupMode[index] = newFieldValue;
                    break;
                case setupFlowControlStr:
                    setupFlowControl[index] = newFieldValue;
                    break;
                case setup802Str:
                    setup802[index] = newFieldValue;
                    break;
                case setupPortPriorityStr:
                    setupPortPriority[index] = newFieldValue;
                    break;
                case setupPortDescriptionStr:
                    setupPortDescription[index] = newFieldValue;
                    break;
                default:
                }
            }
        }

        Component.onCompleted: {
            modeListModel.addMode(qsTr("disable"));
            modeListModel.addMode(qsTr("auto"));
            modeListModel.addMode(qsTr("100Full"));
            modeListModel.addMode(qsTr("100Half"));
            modeListModel.addMode(qsTr("10Full"));
            modeListModel.addMode(qsTr("10Half"));
            modeList.addMode("Off");
            modeList.addMode("Auto");
            modeList.addMode("100Full");
            modeList.addMode("100Half");
            modeList.addMode("10Full");
            modeList.addMode("10Half");

            flowControlListModel.addFlowControl(qsTr("on"));
            flowControlListModel.addFlowControl(qsTr("off"));
            flowControlList.addFlowControl("On");
            flowControlList.addFlowControl("Off");

            priority802ListModel.addPriority802(qsTr("enable"));
            priority802ListModel.addPriority802(qsTr("disable"));
            priority802List.addPriority802("On");
            priority802List.addPriority802("Off");

            portBasePriorityListModel.addPortBasePriority(qsTr("normal"));
            portBasePriorityListModel.addPortBasePriority(qsTr("high"));
            portBasePriorityList.addPortBasePriority("Normal");
            portBasePriorityList.addPortBasePriority("High");
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
                        portSetupGridView.enabled = false;

                        if(possibleChangedItemsIndexes.length == 0) {
                            generalConfigurationMessageDialog.show(qsTr("changes_saved"));
                            return;
                        }

                        possibleChangedItemsIndexes.forEach(function f(element,index,array)
                        {
                            if(checkNewParamValue(setupModeStr, element, localBackup.setupMode[element],
                                     modeList.get(portSetupModel.get(element).mode_idx).text) &&
                               checkNewParamValue(setupFlowControlStr, element, localBackup.setupFlowControl[element],
                                     flowControlList.get(portSetupModel.get(element).flow_control_idx).text) &&
                               checkNewParamValue(setup802Str, element, localBackup.setup802[element],
                                     priority802List.get(portSetupModel.get(element).priority802_idx).text) &&
                               checkNewParamValue(setupPortPriorityStr, element, localBackup.setupPortPriority[element],
                                     portBasePriorityList.get(portSetupModel.get(element).port_base_priority_idx).text) &&
                               checkNewParamValue(setupPortDescriptionStr, element, localBackup.setupPortDescription[element],
                                     portSetupModel.get(element).port_description))
                            {
                                setNewParamValue(setupModeStr, element, localBackup.setupMode[element],
                                     modeList.get(portSetupModel.get(element).mode_idx).text);
                                setNewParamValue(setupFlowControlStr, element, localBackup.setupFlowControl[element],
                                      flowControlList.get(portSetupModel.get(element).flow_control_idx).text);
                                setNewParamValue(setup802Str, element, localBackup.setup802[element],
                                      priority802List.get(portSetupModel.get(element).priority802_idx).text);
                                setNewParamValue(setupPortPriorityStr, element, localBackup.setupPortPriority[element],
                                      portBasePriorityList.get(portSetupModel.get(element).port_base_priority_idx).text);
                                setNewParamValue(setupPortDescriptionStr, element, localBackup.setupPortDescription[element],
                                      portSetupModel.get(element).port_description);
                                possibleChangedItemsIndexes = []
                                generalConfigurationMessageDialog.show(qsTr("changes_saved"));
                            }
                            else {
                                portSetupGridView.enabled = true;
                                return;
                            }
                        });
                    }
                    else {
                        portSetupGridView.enabled = true;
                    }
                    userEditingConfiguration = !userEditingConfiguration;
                }

                function checkNewParamValue(paramName, index, paramValue, newParamValue)
                {
                    var hasChanges = paramValue.localeCompare(newParamValue);
                    if (hasChanges !== 0) {
                        var res = socketcontroller.permitSetParamInfo(paramName,
                                                portSetupModel.getChild(index).port + " " + newParamValue);
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
                                 portSetupModel.get(index).port + " " + newParamValue);
                        if(res === 1) {
                            localBackup.updateField(paramName, index, newParamValue);
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
            anchors.leftMargin: 15
            anchors.rightMargin: 15

            Flickable{
                anchors.fill: parent
                flickableDirection: Flickable.VerticalFlick
                contentHeight: portSetupGridView.cellHeight*portSetupModel.count
                clip: true

                GridView {
                    id: portSetupGridView
                    anchors.centerIn: parent
                    enabled: false
                    Layout.fillWidth: true
                    anchors.fill: parent
                    cellHeight: ((columnLayout.height + columnLayout.width)/fontCoefficient + bottomMargin*2)*32//230
                    cellWidth: portSetupSubtabId.width
                    model: portSetupModel
                    clip: true
                    delegate: portSetupDelegate
                }
            }
        }
        Component{
            id: portSetupDelegate

            Item {
                height: portSetupGridView.cellHeight
                width: portSetupGridView.cellWidth

                GridLayout{
                    anchors.centerIn: parent
                    columns: 4

                    Text{
                        Layout.columnSpan: 4
                        Layout.fillWidth: true
                        font.letterSpacing: 1
                        color: "darkGreen"
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        text: qsTr("port_num") + " #" + model.port
                    }

                    Text{
                        text: qsTr("mode")
                        font.letterSpacing: 1
                        Layout.columnSpan: 2
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.fillWidth: true
                    }

                    ComboBox{
                        id: modeValueCombobox
                        model: modeListModel
                        Layout.columnSpan: 2
                        currentIndex: mode_idx
                        Layout.fillWidth: true
                        property bool loading: true

                        onCurrentIndexChanged: {
                            if(!loading) {
                                addPossibleChangeIndex(index);
                                portSetupModel.set(index,{"mode_idx" : modeValueCombobox.currentIndex})
                            }
                        }

                        Component.onCompleted: {
                            loading = false;
                        }
                    }

                    Text{
                        text: qsTr("flow_control")
                        Layout.fillWidth: true
                        font.letterSpacing: 1
                        Layout.columnSpan: 2
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                    }

                    ComboBox{
                        id: flowControlValueCombobox
                        model: flowControlListModel
                        currentIndex: flow_control_idx
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        property bool loading: true

                        onCurrentIndexChanged: {
                            if(!loading) {
                                addPossibleChangeIndex(index);
                                portSetupModel.set(index,{"flow_control_idx" : flowControlValueCombobox.currentIndex})
                            }
                        }

                        Component.onCompleted: {
                            loading = false;
                        }
                    }

                    Text{
                        text: qsTr("priority802")
                        Layout.fillWidth: true
                        font.letterSpacing: 1
                        Layout.columnSpan: 2
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                    }

                    ComboBox{
                        id: priority802ValueCombobox
                        model: priority802ListModel
                        currentIndex: priority802_idx
                        Layout.fillWidth: true
                        Layout.columnSpan: 2
                        property bool loading: true

                        onCurrentIndexChanged: {
                            if(!loading) {
                                addPossibleChangeIndex(index);
                                portSetupModel.set(index,{"priority802_idx" : priority802ValueCombobox.currentIndex})
                            }
                        }

                        Component.onCompleted: {
                            loading = false;
                        }
                    }

                    Text{
                        text: qsTr("port_base_priority")
                        Layout.fillWidth: true
                        font.letterSpacing: 1
                        Layout.columnSpan: 2
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                    }

                    ComboBox{
                        id: portBasePriorityValueCombobox
                        model: portBasePriorityListModel
                        currentIndex: post_base_priority_idx
                        Layout.fillWidth: true
                        Layout.columnSpan: 2
                        property bool loading: true

                        onCurrentIndexChanged: {
                            if(!loading) {
                                addPossibleChangeIndex(index);
                                portSetupModel.set(index,{"port_base_priority_idx" : portBasePriorityValueCombobox.currentIndex})
                            }
                        }

                        Component.onCompleted: {
                            loading = false;
                        }
                    }

                    Text{
                        text: qsTr("port_description")
                        Layout.fillWidth: true
                        font.letterSpacing: 1
                        Layout.columnSpan: 2
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                    }

                    TextField{
                        id: portDescriptionValueTextField
                        text: port_description
                        Layout.fillWidth: true
                        Layout.columnSpan: 2
                        font.letterSpacing: 1
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient

                        property bool loading: true

                        onTextChanged: {
                            if(!loading) {
                                addPossibleChangeIndex(index);
                                portSetupModel.set(index,{"port_description" : portDescriptionValueTextField.text})
                            }
                        }

                        Component.onCompleted: {
                            loading = false;
                        }
                    }
                }
            }
        }

        //possible values from server
        ListModel{
            id: modeList
            objectName: "modeList"

            function addMode(mode)
            {
                append({text: mode})
            }

            function getChild(index)
            {
                return get(index)
            }
        }

        // translation
        ListModel{
            id: modeListModel
            objectName: "modeListModel"

            function addMode(mode)
            {
                append({text: mode})
            }

            function getChild(index)
            {
                return get(index)
            }
        }

        //possible values from server
        ListModel{
            id: flowControlList
            objectName: "flowControlList"

            function addFlowControl(flowControl)
            {
                append({text: flowControl})
            }

            function getChild(index)
            {
                return get(index)
            }
        }

        // translation
        ListModel{
            id: flowControlListModel
            objectName: "flowControlListModel"

            function addFlowControl(flowControl)
            {
                append({text: flowControl})
            }

            function getChild(index)
            {
                return get(index)
            }
        }

        //possible values from server
        ListModel{
            id: priority802List
            objectName: "priority802List"

            function addPriority802(priority802)
            {
                append({text: priority802})
            }

            function getChild(index)
            {
                return get(index)
            }
        }

        // translation
        ListModel{
            id: priority802ListModel
            objectName: "priority802ListModel"

            function addPriority802(priority802)
            {
                append({text: priority802})
            }

            function getChild(index)
            {
                return get(index)
            }
        }

        //possible values from server
        ListModel{
            id: portBasePriorityList
            objectName: "portBasePriorityList"

            function addPortBasePriority(priority)
            {
                append({text: priority})
            }

            function getChild(index)
            {
                return get(index)
            }
        }

        // translation
        ListModel{
            id: portBasePriorityListModel
            objectName: "portBasePriorityListModel"

            function addPortBasePriority(priority)
            {
                append({text: priority})
            }

            function getChild(index)
            {
                return get(index)
            }
        }

        ListModel {
            id: portSetupModel
            objectName: "portSetupModel"

            function addPortSetupData(port_, mode_idx_, flow_control_idx_,
                                      priority802_idx_, port_base_priority_idx_,
                                      port_description_)
            {
                append({port: port_, mode_idx: mode_idx_,
                           flow_control_idx: flow_control_idx_,
                           priority802_idx: priority802_idx_,
                           port_base_priority_idx: port_base_priority_idx_,
                           port_description: port_description_})

                localBackup.setupMode.push(modeList.get(mode_idx_).text)
                localBackup.setupFlowControl.push(flowControlList.get(flow_control_idx_).text)
                localBackup.setup802.push(priority802List.get(priority802_idx_).text)
                localBackup.setupPortPriority.push(portBasePriorityList.get(port_base_priority_idx_).text)
                localBackup.setupPortDescription.push(port_description_)
            }

            function getChild(index)
            {
                return get(index)
            }
        }
    }
}
