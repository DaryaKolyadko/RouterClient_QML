import QtQuick 2.0
import QtQuick.Controls 1.2

Item {
    id: miscConfigurationTabId

    Connections {
        target: socketcontroller
    }

    function redirectToFirstTab()
    {
        miscConfigurationInnerTabView.currentIndex  = 0;
    }

    function cleanAccountPage() {
        accountSettingsSubtab.item.clean();
    }

    TabView{
        id: miscConfigurationInnerTabView
        objectName: "miscConfigurationInnerTabView"
        anchors.fill: parent

        Tab{
            id: accountSettingsSubtab
            objectName: "accountSettingsSubtab"
            title: qsTr("account_settings")
            active: true
            anchors.fill: parent

            function clean() {
                accountSettingsInner.clean();
            }

            AccountSettingsSubtab{
                id: accountSettingsInner
                objectName: "accountSettingsInner"
                anchors.fill: parent
            }
        }

        RestoreSystemSubtab{
            id: restoreSystemSubtab
            objectName: "restoreSystemSubtab"
            active: true
            anchors.fill: parent
        }

        RebootSystemSubtab{
            id: rebootSystemSubtab
            objectName: "rebootSystemSubtab"
            active: true
            anchors.fill: parent
        }

        FirmwareUpgradeSubtab{
            id: firmwareUpgradeSubtab
            objectName: "firmwareUpgradeSubtab"
            active: true
            anchors.fill: parent
        }
    }
}
