import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item {
    id: poeTabId
    property bool userEditingConfiguration: false
    property int bottomMargin: 15//resolution.dp(15) // 15
    property int topMargin: 50
    property string portStatusStr: "PoePortStatus"
    property string portPriorityStr: "PoePortPriority"
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
                        poeSetupGridView.enabled = false;

                        if(possibleChangedItemsIndexes.length == 0) {
                            generalConfigurationMessageDialog.show(qsTr("changes_saved"));
                            return;
                        }

                        possibleChangedItemsIndexes.forEach(function f(element,index,array)
                        {
                            if(checkNewParamValue(portStatusStr, element, localBackup.portStatus[element],
                                     statusList.get(poeSetupModel.get(element).status_idx).text) &&
                               checkNewParamValue(portPriorityStr, element, localBackup.portPriority[element],
                                     priorityList.get(poeSetupModel.get(element).priority_idx).text))
                            {
                                setNewParamValue(portStatusStr, element, localBackup.portStatus[element],
                                                statusList.get(poeSetupModel.get(element).status_idx).text);
                                setNewParamValue(portPriorityStr, element, localBackup.portPriority[element],
                                                priorityList.get(poeSetupModel.get(element).priority_idx).text);
                                possibleChangedItemsIndexes = []
                                generalConfigurationMessageDialog.show(qsTr("changes_saved"));
                            }
                            else {
                                poeSetupGridView.enabled = true;
                                return;
                            }
                        });
                    }
                    else {
                        poeSetupGridView.enabled = true;
                    }
                    userEditingConfiguration = !userEditingConfiguration;
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
                                poeSetupModel.get(index).port + " " + newParamValue);
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
                id: updatePoeSetupListButton
                text: qsTr("update_poe_setup_list")
                Layout.fillWidth: true
                onClicked: {
                    socketcontroller.getPoeSetupList();
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
                contentHeight: poeSetupGridView.cellHeight*poeSetupModel.count
                clip: true

//                GridLayout {
//                    id: mainConfigurationGridLayout
//                    columns: 1
//                    anchors.centerIn: parent
//                    enabled: false
//                    Layout.fillWidth: true
//                    clip: true

                GridView {
                    id: poeSetupGridView
                    //anchors.centerIn: parent
                    enabled: false
                    Layout.fillWidth: true
                    anchors.fill: parent
                    cellHeight: ((columnLayout.height + columnLayout.width)/fontCoefficient + bottomMargin*2)*32//230
                    cellWidth: poeTabId.width
                    model: poeSetupModel
                    clip: true
                    delegate: poeSetupDelegate
                }
            }
            //}
        }
        Component{
            id: poeSetupDelegate

            Item {
                height: poeSetupGridView.cellHeight
                width: poeSetupGridView.cellWidth

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
                        text: qsTr("status")
                        font.letterSpacing: 1
                        Layout.columnSpan: 2
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.fillWidth: true
                    }

                    ComboBox{
                        id: statusCombobox
                        model: statusListModel
                        Layout.columnSpan: 2
                        currentIndex: status_idx
                        Layout.fillWidth: true
                        property bool loading: true

                        onCurrentIndexChanged: {
                            if(!loading) {
                                addPossibleChangeIndex(index);
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
                        Layout.columnSpan: 2
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                    }

                    Text{
                        text: delivering_power
                        font.letterSpacing: 1
                        Layout.columnSpan: 2
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.fillWidth: true
                    }

                    Text{
                        text: qsTr("current_ma")
                        Layout.fillWidth: true
                        font.letterSpacing: 1
                        Layout.columnSpan: 2
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                    }

                    Text{
                        text: current_ma
                        font.letterSpacing: 1
                        Layout.columnSpan: 2
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.fillWidth: true
                    }

                    Text{
                        text: qsTr("power_limit_w")
                        Layout.fillWidth: true
                        font.letterSpacing: 1
                        Layout.columnSpan: 2
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                    }

                    Text{
                        text: power_limit_w
                        font.letterSpacing: 1
                        Layout.columnSpan: 2
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.fillWidth: true
                    }

                    Text{
                        text: qsTr("priority")
                        Layout.fillWidth: true
                        font.letterSpacing: 1
                        Layout.columnSpan: 2
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                    }

                    ComboBox{
                        id: priorityCombobox
                        model: priorityList
                        currentIndex: priority_idx
                        Layout.fillWidth: true
                        Layout.columnSpan: 2
                        property bool loading: true

                        onCurrentIndexChanged: {
                            if(!loading) {
                                addPossibleChangeIndex(index);
                                poeSetupModel.set(index,{"priority_idx" : priorityCombobox.currentIndex})
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
