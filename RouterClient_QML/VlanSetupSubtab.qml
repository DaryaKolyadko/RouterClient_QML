import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4


ScrollView {
    id: vlanSetupId
    implicitWidth: 650
    implicitHeight: 200
    clip: true
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    property alias vlanBackup: localBackup
    property alias vlanCurrent: currentVlanModel
    property alias innerContent: content
    property alias possibleChangedItemIndexes: content.possibleChangedItemsIndexes
    property int vlanCount: 8
    property int portCount: 8
    property int portPvidId: -1
    property int portTaggingId: -2
    property string portPvidStr: "PortPvid"
    property string portTaggingStatusStr: "PortTaggingStatus"
    property bool init: false;
    property int fontCoefficient: 100

    Item {
        id: content
        enabled: false
        width: Math.max(vlanSetupId.viewport.width, vlanSettings.implicitWidth + 2 * vlanSettings.rowSpacing)
        height: Math.max(vlanSetupId.viewport.height, vlanSettings.implicitHeight + 2 * vlanSettings.columnSpacing)
        property bool portTaggingShow: false

        property var regexPvid: /\b(?:(?:[1-8]?))\b/

        Connections {
            target: socketcontroller
        }

        function setVisible(name){
            vlanSettings.visible = false;

            if (name === "portBased")
            {
                vlanSettings.visible = true;
                portTaggingShow = false;
            }
            else if (name === "802.1q")
            {
                vlanSettings.visible = true;
                portTaggingShow = true;
            }
        }

        property var possibleChangedItemsIndexes: []

        function addPossibleChangeIndex(port, vlan)
        {
            var flag = false;

            possibleChangedItemsIndexes.forEach(function f(element,index,array)
            {
                if (element.port === port && element.vlan === vlan)
                {
                    flag = true;
                    return;
                }
            });

            if(flag)
                return;

            possibleChangedItemsIndexes.push({port: port, vlan: vlan});
        }

        Item{
            id: localBackup
            objectName: "localBackup"
            property var portsAndVlans: []
            property var portsPvid: []
            property var portsTagging: []

            function updateField(port, vlan, newFieldValue)
            {
                portsAndVlans[port][vlan] = newFieldValue;
            }

            function updateFieldByName(fieldName, port, newFieldValue)
            {
                switch (fieldName) {
                case portPvidStr:
                    portsPvid[port] = newFieldValue;
                    break;
                case portTaggingStatusStr:
                    portsTagging[port] = newFieldValue;
                    break;
                default:
                }
            }
        }

        Item {
            id: currentVlanModel
            objectName: "currentVlanModel"
            property var portsAndVlans: []
            property var portsPvid: []
            property var portsTagging: []

            function init(portCount, vlanCount){
                portsAndVlans = []
                localBackup.portsAndVlans = []

                for(var i = 0; i < portCount; i++)
                {
                    portsAndVlans[i] = []
                    localBackup.portsAndVlans[i] = []

                    for(var j = 0; j < vlanCount; j++)
                    {
                        portsAndVlans[i].push(false)
                        localBackup.portsAndVlans[i].push(false)
                    }
                }
            }

            function updateField(port, vlan, newFieldValue)
            {
                portsAndVlans[port][vlan] = newFieldValue;
            }

            function addPortVlanEnabled(port, vlan)
            {
                port--;
                vlan--;
                updateField(port, vlan, true);
                localBackup.updateField(port, vlan, true);
                setCheck(port, vlan);
            }

            function setPortPvid(port, pvid)
            {
                port--;
                portsPvid[port] = pvid;
                localBackup.portsPvid[port] = pvid;
                portRepeater.itemAt(port).children[1].children[vlanCount + 1].
                children[1].text = pvid;
            }

            function setCheck(port, vlan)
            {
                //var contentItem = portRepeater.itemAt(port).children[1].children[vlan].checkBoxIndex;
                portRepeater.itemAt(port).children[1].children[vlan].checked = true;
            }

            function deleteAllChecks()
            {
                for(var port = 0; port < portCount; port++)
                {
                    for(var vlan = 0; vlan < vlanCount; vlan++)
                        portRepeater.itemAt(port).children[1].children[vlan].checked = false;
                }
            }

            function setPortTaggingStatus(port, value)
            {
                port--;
                portsTagging[port] = taggingStatusList.get(value).text;
                localBackup.portsTagging[port] = taggingStatusList.get(value).text;
                portRepeater.itemAt(port).children[1].children[vlanCount + 2].
                children[1].currentIndex = value;
            }
        }

        Component.onCompleted: {
            taggingStatusList.addTaggingStatus("Off");
            taggingStatusList.addTaggingStatus("On");
            taggingStatusListModel.addTaggingStatus(qsTr("untag"));
            taggingStatusListModel.addTaggingStatus(qsTr("tagged"));
        }

        GridLayout {
            id: vlanSettings
            objectName: "vlanSettings"
            visible: false
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: vlanSetupId.width*0.04
            anchors.rightMargin: vlanSettings.rowSpacing
            anchors.topMargin: vlanSettings.columnSpacing
            clip: true

            Column {
                spacing: vlanSetupId.width*0.04

                Repeater{
                    id: portRepeater
                    objectName: "portRepeater"

                    Column{
                        objectName: "columnI"
                        spacing: 10

                        Text{
                            objectName: "textPort"
                            color: "darkGreen"
                            font.pointSize: (vlanSetupId.viewport.height + vlanSetupId.width)/(fontCoefficient - 20)
                            text: qsTr("port_num") + " #" + (index+1)
                        }
                        Column {
                            id: currentRow
                            property int rowIndex: index
                            spacing: 10
                            objectName: "columnVlans"

                            Repeater {
                                id: vlanRepeater
                                objectName: "vlanRepeater"
                                model:  vlanCount

                                CheckBox {
                                    id:vlanCheckbox
                                    objectName: "vlanCheckBox"
                                    height: (vlanSetupId.height + vlanSetupId.width)/(fontCoefficient - 40)
                                    width: (vlanSetupId.height + vlanSetupId.width)/fontCoefficient
                                    style: CheckBoxStyle{
                                        label: Text{
                                            text: qsTr("vlan_num") + "# " + (index + 1) //"port " + currentRow.rowIndex + " vlan " + (index + 1)
                                            font.pointSize:  (vlanSetupId.height + vlanSetupId.width)/fontCoefficient
                                        }
                                    }

                                    // for debugging
                                    property string checkBoxIndex: "port " + (currentRow.rowIndex + 1) + " vlan " + (index + 1)

                                    property bool loading: true

                                    onCheckedChanged: {
                                        if(!loading && !init) {
                                            content.addPossibleChangeIndex(currentRow.rowIndex, index);
                                            currentVlanModel.updateField(currentRow.rowIndex, index, checked);
                                        }
                                    }

                                    Component.onCompleted: {
                                        loading = false;
                                    }
                                }
                            }

                            RowLayout{
                                objectName: "rowLayout"
                                Text{
                                    objectName: "portPvidText"
                                    font.pointSize: (vlanSetupId.height + vlanSetupId.width)/fontCoefficient
                                    text: qsTr("portPvidText")
                                }

                                TextField{
                                    id: portPvid
                                    objectName: "portPvidTextField"
                                    font.letterSpacing: 1
                                    font.pointSize: (vlanSetupId.height + vlanSetupId.width)/fontCoefficient
                                    style: MyTextFieldStyle{id: portpvidfield}
                                    property bool loading: true
                                    validator: RegExpValidator{
                                        regExp: content.regexPvid
                                    }

                                    onTextChanged: {
                                        if(!loading && !init) {
                                            content.addPossibleChangeIndex(currentRow.rowIndex, portPvidId); // -1 => portPvid
                                            currentVlanModel.portsPvid[currentRow.rowIndex] = portPvid.text;
                                        }
                                    }

                                    Component.onCompleted: {
                                        loading = false;
                                    }
                                }
                            }

                            RowLayout{
                                Text{
                                    font.pointSize: (vlanSetupId.height + vlanSetupId.width)/fontCoefficient
                                    text: qsTr("portTagging")
                                    visible: content.portTaggingShow
                                }

                                ComboBox{
                                    id: portTaggingComboBox
                                    visible: content.portTaggingShow
                                    model: taggingStatusListModel
                                    property bool loading: true

                                    onCurrentIndexChanged: {
                                        if(!loading && !init) {
                                            content.addPossibleChangeIndex(currentRow.rowIndex, portTaggingId); // -2 => portTagging
                                            currentVlanModel.portsTagging[currentRow.rowIndex] = taggingStatusList.get(currentIndex).text;
                                        }
                                    }

                                    Component.onCompleted: {
                                        loading = false;
                                    }
                                }
                            }
                        }
                    }
                }
            }

            //possible values from server
            ListModel{
                id: taggingStatusList
                objectName: "taggingStatusList"

                function addTaggingStatus(taggingStatus)
                {
                    append({text: taggingStatus})
                }

                function getChild(index)
                {
                    return get(index)
                }
            }

            // translation
            ListModel{
                id: taggingStatusListModel
                objectName: "taggingStatusListModel"

                function addTaggingStatus(taggingStatus)
                {
                    append({text: taggingStatus})
                }

                function getChild(index)
                {
                    return get(index)
                }
            }
        }
    }
}
