import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ScrollView {
    id:poeSetupId
    implicitWidth: 650
    implicitHeight: 200
    clip: true
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    property int bottomMargin: 15//resolution.dp(15) // 15
    property int topMargin: 50
    property string portStatusStr: "PoePortStatus"
    property string portPriorityStr: "PoePortPriority"
    property int fontCoefficient: 85
    property alias possibleChangedItemIndexes: content.possibleChangedItemsIndexes
    property alias innerContent: content

    Item {
        id: content
        enabled: false
        width: Math.max(poeSetupId.viewport.width, poeSetup.implicitWidth + 2 * poeSetup.rowSpacing)
        height: Math.max(poeSetupId.viewport.height, poeSetup.implicitHeight + 2 * poeSetup.columnSpacing)

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

        Connections {
            target: socketcontroller
        }

        Item {
            id: localBackup
            objectName: "localBackup"
            property var portStatus: []
            property var portPriority: []

            function updateField(fieldName, index, newFieldValue)
            {
                switch (fieldName) {
                case portStatusStr:
                    portStatus[index] = newFieldValue;
                    break;
                case portPriorityStr:
                    portPriority[index] = newFieldValue;
                    break;
                default:
                }
            }
        }

        InfoMessageDialog {
            id: poeMessageDialog
        }

        ErrorInfoDialog{
            id: poeErrorDialog

            function doAction()
            {
                socketcontroller.logOutSignal();
            }
        }

        Component.onCompleted: {
            statusListModel.addStatus(qsTr("enable"));
            statusListModel.addStatus(qsTr("disable"));
            statusList.addStatus("On");
            statusList.addStatus("Off");
            priorityList.addPriority("0");
            priorityList.addPriority("1");
            priorityList.addPriority("2");
            priorityList.addPriority("3");
            //for (var i = 0; i < 4; i++)
            //    priorityList.addPriority(i);
        }

        function checkNewParamValue(paramName, index, paramValue, newParamValue)
        {
            var hasChanges = paramValue.localeCompare(newParamValue);
            if (hasChanges !== 0) {
                var res = socketcontroller.permitSetParamInfo(paramName,
                                                              poeSetupModel.getChild(index).port + " " + newParamValue);
                if(res === 1)
                    return true;
                else if (res === 0)
                    poeMessageDialog.show(qsTr("error_setting").arg(paramName).arg(newParamValue));
                else // new
                    poeErrorDialog.show(qsTr("connection_lost"));
                return false;
            }
            return true;
        }

        function setNewParamValue(paramName, index, paramValue, newParamValue)
        {
            var hasChanges = paramValue.localeCompare(newParamValue);
            if (hasChanges !== 0) {
                var res = socketcontroller.setParamInfo(paramName,
                                                        poeSetupModel.get(index).port + " " + newParamValue);
                if(res === 1) {
                    localBackup.updateField(paramName, index, newParamValue);
                    return true;
                }
                return false;
            }
            return true;
        }

        function checkAllParams(element)
        {
            return checkNewParamValue(portStatusStr, element, localBackup.portStatus[element],
                                      statusList.get(poeSetupModel.get(element).status_idx).text) &&
                    checkNewParamValue(portPriorityStr, element, localBackup.portPriority[element],
                                       priorityList.get(poeSetupModel.get(element).priority_idx).text)
        }

        function setAllParams(element)
        {
            return setNewParamValue(portStatusStr, element, localBackup.portStatus[element],
                                    statusList.get(poeSetupModel.get(element).status_idx).text) &&
                    setNewParamValue(portPriorityStr, element, localBackup.portPriority[element],
                                     priorityList.get(poeSetupModel.get(element).priority_idx).text);
        }

        GridLayout {
            id: poeSetup
            objectName: "poeSetup"
            anchors.centerIn: parent
            anchors.topMargin: poeSetup.columnSpacing
            clip: true

            Column {
                spacing: poeSetupId.width*0.04

                Repeater{
                    id: poeRepeater
                    objectName: "poeRepeater"
                    model: poeSetupModel

                    GridLayout{
                        objectName: "columnI"
                        rowSpacing: 10
                        columns: 2

                        Text{
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            font.letterSpacing: 1
                            color: "darkGreen"
                            font.pointSize: (poeSetupId.viewport.height + poeSetupId.width)/fontCoefficient
                            text: qsTr("port_num") + " #" + model.port
                        }

                        Text{
                            text: qsTr("status")
                            font.letterSpacing: 1
                            font.pointSize: (poeSetupId.viewport.height + poeSetupId.width)/fontCoefficient
                            Layout.fillWidth: true
                        }

                        ComboBox{
                            id: statusCombobox
                            model: statusListModel
                            currentIndex: status_idx
                            Layout.fillWidth: true
                            property bool loading: true

                            onCurrentIndexChanged: {
                                if(!loading) {
                                    content.addPossibleChangeIndex(index);
                                    poeSetupModel.set(index,{"status_idx" : statusCombobox.currentIndex})
                                }
                            }

                            Component.onCompleted: {
                                loading = false;
                            }
                        }

                        Text{
                            text: qsTr("delivering_power_w")
                            Layout.fillWidth: true
                            font.letterSpacing: 1
                            font.pointSize: (poeSetupId.viewport.height + poeSetupId.width)/fontCoefficient
                        }

                        Text{
                            text: delivering_power + " W"
                            font.letterSpacing: 1
                            font.pointSize: (poeSetupId.viewport.height + poeSetupId.width)/fontCoefficient
                            Layout.fillWidth: true
                        }

                        Text{
                            text: qsTr("current_ma")
                            Layout.fillWidth: true
                            font.letterSpacing: 1
                            font.pointSize: (poeSetupId.viewport.height + poeSetupId.width)/fontCoefficient
                        }

                        Text{
                            text: current_ma + " mA"
                            font.letterSpacing: 1
                            font.pointSize: (poeSetupId.viewport.height + poeSetupId.width)/fontCoefficient
                            Layout.fillWidth: true
                        }

                        Text{
                            text: qsTr("power_limit_w")
                            Layout.fillWidth: true
                            font.letterSpacing: 1
                            font.pointSize: (poeSetupId.viewport.height + poeSetupId.width)/fontCoefficient
                        }

                        Text{
                            text: power_limit_w + " W"
                            font.letterSpacing: 1
                            font.pointSize: (poeSetupId.viewport.height + poeSetupId.width)/fontCoefficient
                            Layout.fillWidth: true
                        }

                        Text{
                            text: qsTr("priority")
                            Layout.fillWidth: true
                            font.letterSpacing: 1
                            font.pointSize: (poeSetupId.viewport.height + poeSetupId.width)/fontCoefficient
                        }

                        ComboBox{
                            id: priorityCombobox
                            model: priorityList
                            currentIndex: priority_idx
                            Layout.fillWidth: true
                            property bool loading: true

                            onCurrentIndexChanged: {
                                if(!loading) {
                                    content.addPossibleChangeIndex(index);
                                    //poeSetupModel.set(index,{"priority_idx" : priorityCombobox.currentIndex})
                                    poeSetupModel.setProperty(index, "priority_idx", priorityCombobox.currentIndex);
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
                id: statusList
                objectName: "statusList"

                function addStatus(status)
                {
                    append({text: status})
                }

                function getChild(index)
                {
                    return get(index)
                }
            }

            // translation
            ListModel{
                id: statusListModel
                objectName: "statusListModel"

                function addStatus(status)
                {
                    append({text: status})
                }

                function getChild(index)
                {
                    return get(index)
                }
            }

            //possible values from server
            ListModel{
                id: priorityList
                objectName: "priorityList"

                function addPriority(priority)
                {
                    append({text: priority})
                }

                function getChild(index)
                {
                    return get(index)
                }
            }

            ListModel {
                id: poeSetupModel
                objectName: "poeSetupModel"

                function addPoeSetupData(port_, status_idx_, delivering_power_,
                                         current_ma_, power_limit_w_,
                                         priority_idx_)
                {
                    append({port: port_, status_idx: status_idx_,
                               delivering_power: delivering_power_,
                               current_ma: current_ma_,
                               power_limit_w: power_limit_w_,
                               priority_idx: priority_idx_})

                    localBackup.portStatus.push(statusList.get(status_idx_).text)
                    localBackup.portPriority.push(priorityList.get(priority_idx_).text)
                }

                function getChild(index)
                {
                    return get(index)
                }
            }
        }
    }
}
