import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1


Tab{
    id: wifiConfigTabId
    title: qsTr("wifi")
    active: true
    property bool userEditingConfiguration: false
    property int bottomMargin: 15//resolution.dp(15)//15
    property int fontCoefficient: 100//resolution.dp(100)//100
    property string ssidStr: "Ssid"
    property string wifiStatusStr: "WifiStatus"
    property string frequencyRangeStr: "FrequencyRange"

    Connections {
        target: socketcontroller
    }

    ColumnLayout{
        id: wifiConfiguration
        anchors.fill: parent

        InfoMessageDialog {
            id: wifiConfigurationMessageDialog
        }

        ErrorInfoDialog {
            id: wifiConfigurationErrorDialog

            function doAction()
            {
                socketcontroller.logOutSignal();
            }
        }

        RowLayout{
            id: rowLayoutId
            Layout.fillWidth: true
            anchors.top: parent.top
            anchors.bottomMargin: bottomMargin

            Button{
                id: changeWifiConfiguration
                text: userEditingConfiguration ? qsTr("save_settings") : qsTr("change_settings")
                Layout.columnSpan: 3
                Layout.fillWidth: true
                anchors.bottomMargin: bottomMargin
                onClicked: {
                    if(userEditingConfiguration) {
                        wifiConfigSubtab.innerContent.enabled = false;
                        if(wifiConfigSubtab.innerContent.checkAllParams())
                        {
                            wifiConfigSubtab.innerContent.setAllParams();
                            wifiConfigurationMessageDialog.show(qsTr("changes_saved"));
                        }
                        else {
                            wifiConfigSubtab.innerContent.enabled = true;
                            return;
                        }
                    }
                    else
                        wifiConfigSubtab.innerContent.enabled = true;
                    userEditingConfiguration = !userEditingConfiguration;
                }
            }

            Button{
                id: updateWifiConfiguraionButton
                text: qsTr("update_wifi_config")
                Layout.fillWidth: true
                onClicked: {
                    socketcontroller.getWifiConfiguration();
                }
            }
        }

        ColumnLayout{
            anchors.top: rowLayoutId.bottom
            anchors.bottom: parent.bottom

            WifiConfigurationSubtab{
                id: wifiConfigSubtab
                objectName: "wifiConfigurationSubtab"
                anchors.fill: parent
                clip: true
                Layout.fillWidth: true
            }
        }
    }
}
