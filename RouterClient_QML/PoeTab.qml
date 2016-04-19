import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item {
    id: poeTabId

    Connections {
        target: socketcontroller
    }

    function redirectToFirstTab()
    {
        poeTabView.currentIndex  = 0;
    }

    TabView{
        id: poeTabView
        anchors.fill: parent

        Tab {
            id: poeSubtabId
            active: true
            title: qsTr("poe_subtab")
            property bool userEditingConfiguration: false
            property int bottomMargin: 1
            property int topMargin: 50

            ColumnLayout{
                id: columnLayout
                anchors.fill: parent

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
                                poeSubtab.innerContent.enabled = false;

                                if(poeSubtab.possibleChangedItemIndexes.length == 0) {
                                    poeMessageDialog.show(qsTr("changes_saved"));
                                    userEditingConfiguration = !userEditingConfiguration;
                                    return;
                                }

                                poeSubtab.possibleChangedItemIndexes.forEach(function f(element,index,array)
                                {
                                    if(poeSubtab.innerContent.checkAllParams(element))
                                    {
                                        var setSuccess = poeSubtab.innerContent.setAllParams(element);

                                        poeSubtab.possibleChangedItemIndexes = []
                                        if(setSuccess)
                                            poeMessageDialog.show(qsTr("changes_saved"));
                                    }
                                    else {
                                        poeSubtab.innerContent.enabled = true;
                                        return;
                                    }
                                });
                            }
                            else {
                                poeSubtab.innerContent.enabled = true;
                            }
                            userEditingConfiguration = !userEditingConfiguration;
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
                    anchors.left: columnLayout.left
                    anchors.right: columnLayout.right
                    anchors.bottom: columnLayout.bottom

                    PoeSubtab{
                        id: poeSubtab
                        objectName: "poeSubtab"
                        anchors.fill: parent
                        clip: true
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
