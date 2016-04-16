import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item{
    id: generalConfigurationTabId
    property bool userEditingConfiguration: false
    property int bottomMargin: 15//resolution.dp(15) // 15
    property int topMargin: 50
    property int fontCoefficient: 100//resolution.dp(100)//100
    property string networkMaskStr: "NetworkMask"
    property string hostAddressStr: "HostAddress"
    property string managementVlanStr: "ManagementVlan"
    property string broadcastStormStr: "BroadcastStormControl"
    property string gatewayStr: "Gateway"
    property string systemDescriptionStr: "SystemDescription"
    property var regexSystemDescription: /\b(?:(?:[a-zA-Z0-9_.-]?)){0,20}\b/
    property var regexIpAddress: /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/

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
        }

        Component.onCompleted: {
            for(var i = 1; i <= 8; i++)
                managementVlanListModel.addManagementVlan(i);
            broadcastStormListModel.addBroadcastStorm(qsTr("disable"));
            broadcastStormListModel.addBroadcastStorm("10%");
            broadcastStormListModel.addBroadcastStorm("20%");
            broadcastStormListModel.addBroadcastStorm("40%");
            broadcastStormList.addBroadcastStorm("Off");
            broadcastStormList.addBroadcastStorm("10%");
            broadcastStormList.addBroadcastStorm("20%");
            broadcastStormList.addBroadcastStorm("40%");
        }

        Item{
            id: localBackup
            objectName: "localBackup"
            property string hostAddress: ""
            property string networkMask: ""
            property string managementVlan: ""
            property string broadcastStorm: ""
            property string gateway: ""
            property string systemDescription: ""

            function updateField(fieldName, newFieldValue)
            {
                switch (fieldName) {
                case networkMaskStr:
                    networkMask = newFieldValue;
                    break;
                case hostAddressStr:
                    hostAddress = newFieldValue;
                    break;
                case managementVlanStr:
                    managementVlan = newFieldValue;
                    break;
                case broadcastStormStr:
                    broadcastStorm = newFieldValue;
                    break;
                case gatewayStr:
                    gateway = newFieldValue;
                    break;
                case systemDescriptionStr:
                    systemDescription = newFieldValue;
                    break;
                default:
                }
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
                        mainConfigurationGridLayout.enabled = false;
                        if(checkNewParamValue(hostAddressStr, localBackup.hostAddress, hostAddressTextInput.text) &&
                                checkNewParamValue(networkMaskStr, localBackup.networkMask, networkMaskTextInput.text) &&
                                checkNewParamValue(managementVlanStr, localBackup.managementVlan,
                                                   managementVlanListModel.get(managementVlanComboBox.currentIndex).text) &&
                                checkNewParamValue(broadcastStormStr, localBackup.broadcastStorm,
                                                   broadcastStormList.get(broadcastStormComboBox.currentIndex).text) &&
                                checkNewParamValue(gatewayStr, localBackup.gateway, gatewayTextInput.text) &&
                                checkNewParamValue(systemDescriptionStr, localBackup.systemDescription, systemDescriptionTextInput.text))
                        {
                            setNewParamValue(hostAddressStr, localBackup.hostAddress, hostAddressTextInput.text);
                            setNewParamValue(networkMaskStr, localBackup.networkMask, networkMaskTextInput.text);
                            setNewParamValue(managementVlanStr, localBackup.managementVlan,
                                             managementVlanListModel.get(managementVlanComboBox.currentIndex).text);
                            setNewParamValue(broadcastStormStr, localBackup.broadcastStorm,
                                             broadcastStormList.get(broadcastStormComboBox.currentIndex).text);
                            setNewParamValue(gatewayStr, localBackup.gateway, gatewayTextInput.text);
                            setNewParamValue(systemDescriptionStr, localBackup.systemDescription, systemDescriptionTextInput.text);
                            generalConfigurationMessageDialog.show(qsTr("changes_saved"));
                        }
                        else {
                            mainConfigurationGridLayout.enabled = true;
                            return;
                        }
                    }
                    else {
                        mainConfigurationGridLayout.enabled = true;
                        macAddressTextInput.enabled = false;
                        swVersionTextInput.enabled = false;
                        modelTextInput.enabled = false;
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
                        else if (res === 0)
                            generalConfigurationMessageDialog.show(qsTr("error_setting").arg(paramName).arg(newParamValue));
                        else // new
                            generalConfiguraionErrorDialog.show(qsTr("connection_lost"));
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
                            localBackup.updateField(paramName, newParamValue);
                            return true;
                        }
                        return false;
                    }
                    return true;
                }
            }

        }

        ColumnLayout{
            anchors.top: rowLayoutId.bottom
            anchors.left: columnLayout.left
            anchors.right: columnLayout.right
            anchors.bottom: columnLayout.bottom
            clip: true

            Flickable{
                anchors.fill: parent
                flickableDirection: Flickable.VerticalFlick
                contentHeight: (mainConfigurationGridLayout.height + generalConfigurationTabId.topMargin)

                GridLayout {
                    id: mainConfigurationGridLayout
                    columns: 3
                    anchors.centerIn: parent
                    enabled: false
                    Layout.fillWidth: true
                    clip: true

                    Text{
                        id: hostAddressText
                        font.letterSpacing: 1
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.fillWidth: true
                        anchors.bottomMargin: bottomMargin
                        text: qsTr("host_address")
                    }

                    TextField {
                        id: hostAddressTextInput
                        objectName: "hostAddressTextInput"
                        font.letterSpacing: 1
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        style: MyTextFieldStyle{id: hostaddrfield}
                        anchors.bottomMargin: bottomMargin
                        validator: RegExpValidator{
                            regExp: regexIpAddress
                        }
                    }

                    Text{
                        id: networkMaskText
                        font.letterSpacing: 1
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.fillWidth: true
                        anchors.bottomMargin: bottomMargin
                        text: qsTr("network_mask")
                    }

                    TextField {
                        id:networkMaskTextInput
                        objectName: "networkMaskTextInput"
                        font.letterSpacing: 1
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        anchors.bottomMargin: bottomMargin
                        style: MyTextFieldStyle{id: networkmaskfield}
                        validator: RegExpValidator{
                            regExp: regexIpAddress
                        }
                    }

                    Text{
                        id: macAddressText
                        font.letterSpacing: 1
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.fillWidth: true
                        anchors.bottomMargin: bottomMargin
                        text: qsTr("mac_adddress")
                    }

                    TextField {
                        id:macAddressTextInput
                        objectName: "macAddressTextInput"
                        font.letterSpacing: 1
                        font.pointSize: (columnLayout.height + columnLayout.width)/(fontCoefficient + 10)
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        anchors.bottomMargin: bottomMargin
                        style: MyTextFieldStyle{id: macaddrefield}
                    }

                    Text{
                        id: modelText
                        font.letterSpacing: 1
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.fillWidth: true
                        text: qsTr("model")
                    }

                    TextField {
                        id: modelTextInput
                        objectName: "modelTextInput"
                        font.letterSpacing: 1
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        style: MyTextFieldStyle{id: modelfield}
                    }

                    Text{
                        id: swVersionText
                        font.letterSpacing: 1
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.fillWidth: true
                        anchors.bottomMargin: bottomMargin
                        text: qsTr("sw_version")
                    }

                    TextField {
                        id:swVersionTextInput
                        objectName: "swVersionTextInput"
                        font.letterSpacing: 1
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        anchors.bottomMargin: bottomMargin
                        style: MyTextFieldStyle{id: swversionfield}
                    }

                    Text{
                        id:managementVlanText
                        font.letterSpacing: 1
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.fillWidth: true
                        text: qsTr("management_vlan")
                    }

                    ComboBox {
                        id:managementVlanComboBox
                        objectName: "managementVlanComboBox"
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        model: managementVlanListModel
                        transitions: Transition {
                            NumberAnimation {
                                properties: "height";
                                easing.type: Easing.OutExpo;
                                duration: 1000
                            }
                        }
                    }

                    Text{
                        id:broadcastStormText
                        font.letterSpacing: 1
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.fillWidth: true
                        text: qsTr("broadcast_storm")
                    }

                    ComboBox {
                        id:broadcastStormComboBox
                        objectName: "broadcastStormComboBox"
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        model: broadcastStormListModel
                        transitions: Transition {
                            NumberAnimation {
                                properties: "height";
                                easing.type: Easing.OutExpo;
                                duration: 1000
                            }
                        }
                    }

                    Text{
                        id: gatewayText
                        font.letterSpacing: 1
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.fillWidth: true
                        anchors.bottomMargin: bottomMargin
                        text: qsTr("gateway")
                    }

                    TextField {
                        id:gatewayTextInput
                        objectName: "gatewayTextInput"
                        font.letterSpacing: 1
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        anchors.bottomMargin: bottomMargin
                        style: MyTextFieldStyle{id: gatewayfield}
                        validator: RegExpValidator{
                            regExp: regexIpAddress
                        }
                    }

                    Text{
                        id: systemDescriptionText
                        font.letterSpacing: 1
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.fillWidth: true
                        anchors.bottomMargin: bottomMargin
                        text: qsTr("system_description")
                    }

                    TextField {
                        id:systemDescriptionTextInput
                        objectName: "systemDescriptionTextInput"
                        font.letterSpacing: 1
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        anchors.bottomMargin: bottomMargin
                        style: MyTextFieldStyle{id: systemdescriptionfield}
                        validator: RegExpValidator{
                            regExp: regexSystemDescription
                        }
                    }

                    LimitedEditingText{
                        id: limitedEditing
                        Layout.columnSpan: 3
                        font.pointSize: (columnLayout.height + columnLayout.width)/fontCoefficient/2
                        Layout.fillWidth: true
                        anchors.bottomMargin: bottomMargin
                    }
                }
            }
        }

        ListModel{
            id: managementVlanListModel
            objectName: "managementVlanListModel"

            function addManagementVlan(managementVlan)
            {
                append({text: managementVlan})
            }

            function getChild(index)
            {
                return get(index)
            }
        }
    }

    // possible values from server
    ListModel{
        id: broadcastStormListModel
        objectName: "broadcastStormListModel"

        function addBroadcastStorm(broadcastStorm)
        {
            append({text: broadcastStorm})
        }

        function getChild(index)
        {
            return get(index)
        }
    }

    // translation
    ListModel{
        id: broadcastStormList
        objectName: "broadcastStormList"

        function addBroadcastStorm(broadcastStorm)
        {
            append({text: broadcastStorm})
        }

        function getChild(index)
        {
            return get(index)
        }
    }
}

//    ResolutionController{
//        id: resolution
//    }
