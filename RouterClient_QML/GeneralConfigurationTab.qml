import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item{
    id: generalConfigurationTabId

    Connections {
        target: socketcontroller
    }

    property int bottomMargin: 15//resolution.dp(15) // 15

    function redirectToFirstTab()
    {
        generalTabView.currentIndex  = 0;
    }

    TabView{
        id: generalTabView
        anchors.fill: parent

        Tab{
            id: generalConfigSubtabId
            objectName: "generalConfigTabId"
            title: qsTr("general_config_subtab")
            active: true

            property bool userEditingConfiguration: false
            property int topMargin: 50
            property int fontCoefficient: 100//resolution.dp(100)//100

            ColumnLayout{
                id: columnLayout

                InfoMessageDialog {
                    id: generalConfigurationMessageDialog
                }

                ErrorInfoDialog{
                    id: generalConfiguraionErrorDialog
                }

                RowLayout{
                    id: rowLayoutId
                    Layout.fillWidth: true
                    anchors.top: parent.top
                    anchors.bottomMargin: bottomMargin

                    Button{
                        id: changeConfiguration
                        text: userEditingConfiguration ? qsTr("save_settings") : qsTr("change_settings")
                        Layout.fillWidth: true
                        anchors.bottomMargin: bottomMargin

                        onClicked: {
                            if(userEditingConfiguration) {
                                generalConfigSubtab.innerContent.enabled = false;

                                if(generalConfigSubtab.innerContent.checkAllParams())
                                {
                                    generalConfigSubtab.innerContent.setAllParams();
                                    generalConfigurationMessageDialog.show(qsTr("changes_saved"));
                                }
                                else {
                                    generalConfigSubtab.innerContent.enabled = true;
                                    return;
                                }
                            }
                            else {
                                generalConfigSubtab.innerContent.enabled = true;
                                generalConfigSubtab.innerContent.disableReadonlyFields();
                            }
                            userEditingConfiguration = !userEditingConfiguration;
                        }
                    }

                    Button{
                        id: updateGeneralConfiguraionButton
                        text: qsTr("update_general_config")
                        Layout.fillWidth: true
                        onClicked: {
                            socketcontroller.getGeneralConfigData();
                        }
                    }
                }

                ColumnLayout{
                    anchors.top: rowLayoutId.bottom
                    anchors.bottom: parent.bottom

                    GeneralConfigurationSubtab{
                        id: generalConfigSubtab
                        objectName: "generalConfigurationSubtab"
                        anchors.fill: parent
                        clip: true
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
