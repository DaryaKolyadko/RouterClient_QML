import QtQuick 2.0
import QtQuick.Controls 1.2

Tab {
    id: miscConfigurationTabId
    active: true
    title: qsTr("misc_configuration")

    Connections {
        target: socketcontroller
    }

    TabView{
        id: miscConfigurationInnerTabView
        objectName: "miscConfigurationInnerTabView"
        anchors.fill: parent

        AccountSettingsSubtab{
            id: accountSettingsSubtab
            objectName: "accountSettingsSubtab"
            active: true
            anchors.fill: parent
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
