import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ScrollView {
    id:portSetupId
    implicitWidth: 650
    implicitHeight: 200
    clip: true
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    property alias backup: localBackup
    property alias innerContent: content
    property alias possibleChangedItemIndexes: content.possibleChangedItemsIndexes
    property alias _portSetupModel: portSetupModel
    property alias _modeList: modeList
    property alias _flowControlList: flowControlList
    property alias _priority802List: priority802List
    property alias _portBasePriorityList: portBasePriorityList

    property int bottomMargin: 15//resolution.dp(15) // 15
    property int topMargin: 50
    property string setupModeStr: "SetupMode"
    property string setupFlowControlStr: "SetupFlowControl"
    property string setup802Str: "Setup802"
    property string setupPortPriorityStr: "SetupPortPriority"
    property string setupPortDescriptionStr: "SetupPortDescription"
    property int fontCoefficient: 100

    Item {
        id: content
        enabled: false
        width: Math.max(portSetupId.viewport.width, portSetup.implicitWidth + 2 * portSetup.rowSpacing)
        height: Math.max(portSetupId.viewport.height, portSetup.implicitHeight + 2 * portSetup.columnSpacing)

        Connections {
            target: socketcontroller
        }

        property var possibleChangedItemsIndexes: []

        function addPossibleChangeIndex(index)
        {
            if(possibleChangedItemsIndexes.indexOf(index) != -1)
                return;

            possibleChangedItemsIndexes.push(index);
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

        GridLayout {
            id: portSetup
            objectName: "portSetup"
            anchors.centerIn: parent
            anchors.topMargin: portSetup.columnSpacing
            clip: true

            Column {
                spacing: portSetupId.width*0.04

                Repeater{
                    id: portRepeater
                    objectName: "portRepeater"
                    model: portSetupModel

                    GridLayout{
                        objectName: "columnI"
                        rowSpacing: 10
                        columns: 2

                        Text{
                            font.letterSpacing: 1
                            color: "darkGreen"
                            Layout.columnSpan: 2
                            font.pointSize: (portSetupId.viewport.height + portSetupId.width)/fontCoefficient
                            text: qsTr("port_num") + " #" + model.port
                        }
                        Text{
                            text: qsTr("mode")
                            font.letterSpacing: 1
                            font.pointSize: (portSetupId.viewport.height + portSetupId.width)/fontCoefficient
                        }

                        ComboBox{
                            id: modeValueCombobox
                            model: modeListModel
                            currentIndex: mode_idx
                            property bool loading: true

                            onCurrentIndexChanged: {
                                if(!loading) {
                                    content.addPossibleChangeIndex(index);
                                    portSetupModel.set(index,{"mode_idx" : modeValueCombobox.currentIndex})
                                }
                            }

                            Component.onCompleted: {
                                loading = false;
                            }
                        }

                        Text{
                            text: qsTr("flow_control")
                            font.letterSpacing: 1
                            font.pointSize: (portSetupId.viewport.height + portSetupId.width)/fontCoefficient
                        }

                        ComboBox{
                            id: flowControlValueCombobox
                            model: flowControlListModel
                            currentIndex: flow_control_idx
                            property bool loading: true

                            onCurrentIndexChanged: {
                                if(!loading) {
                                    content.addPossibleChangeIndex(index);
                                    portSetupModel.set(index,{"flow_control_idx" : flowControlValueCombobox.currentIndex})
                                }
                            }

                            Component.onCompleted: {
                                loading = false;
                            }
                        }

                        Text{
                            text: qsTr("priority802")
                            font.letterSpacing: 1
                            font.pointSize: (portSetupId.viewport.height + portSetupId.width)/fontCoefficient
                        }

                        ComboBox{
                            id: priority802ValueCombobox
                            model: priority802ListModel
                            currentIndex: priority802_idx
                            property bool loading: true

                            onCurrentIndexChanged: {
                                if(!loading) {
                                    content.addPossibleChangeIndex(index);
                                    portSetupModel.set(index,{"priority802_idx" : priority802ValueCombobox.currentIndex})
                                }
                            }

                            Component.onCompleted: {
                                loading = false;
                            }
                        }

                        Text{
                            text: qsTr("port_base_priority")
                            font.letterSpacing: 1
                            font.pointSize: (portSetupId.viewport.height + portSetupId.width)/fontCoefficient
                        }

                        ComboBox{
                            id: portBasePriorityValueCombobox
                            model: portBasePriorityListModel
                            currentIndex: post_base_priority_idx
                            property bool loading: true

                            onCurrentIndexChanged: {
                                if(!loading) {
                                    content.addPossibleChangeIndex(index);
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
                            font.pointSize: (portSetupId.viewport.height + portSetupId.width)/fontCoefficient
                        }

                        TextField{
                            id: portDescriptionValueTextField
                            text: port_description
                            font.letterSpacing: 1
                            font.pointSize: (portSetupId.viewport.height + portSetupId.width)/fontCoefficient

                            property bool loading: true

                            onTextChanged: {
                                if(!loading) {
                                    content.addPossibleChangeIndex(index);
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
}
