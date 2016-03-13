import QtQuick 2.0
import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4

Item {
    id: configurationForm
    visible: true
    width: 800//resolution.dp(800) //800
    height: 400// resolution.dp(400)//400
    property int fontCoefficient: 100
    property double barMarginCoefficient: 0.12
    property int bottomMargin: 15//resolution.dp(15)//15
    property Item previousSelect: generalConfigurationTab
    property int previousItemIndex: 0
    property string backgroundColor: "#303030"

    property var nameToTab: {
        "menu_general": generalConfigurationTab,
        "menu_misc_config": miscConfigurationTab,
        "menu_poe": poeTab,
        "menu_ports_config": portsTab,
        "menu_wifi_config": wifiTab,
        "menu_vlan_setup": vlanSetupTab,
        "menu_corporation_info": corporationInfoTab
    }

    Connections {
        target: socketcontroller
        onWifiComboBoxSetText:{
            wifiConfigurationTab.wifiStatusComboVal = text;
        }
    }

    property alias generalConfigurationTab : generalConfigurationTab
    property bool menu_shown: false

    // this rectangle contains the "menu"
    Rectangle {
        id: menu_view_
        anchors.fill: parent
        color: backgroundColor;
        opacity: configurationForm.menu_shown ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 300 } }

        Component {
            id: highlightBar

            Rectangle {
                id: highlightBarRect
                width: menuListView.width
                height:configurationForm.height*0.1;
                Layout.fillWidth: true
                color: "lightGray"
                y: menuListView.currentItem.y;
                x: menuListView.currentItem.x;
                Behavior on y { NumberAnimation
                    {
                        duration: 50;
                        easing.type: Easing.Linear
                    }
                }
            }
        }

        // menu content
        ListView {
            id: menuListView

            anchors
            {
                fill: parent;
                margins: 10
            }

            highlight: highlightBar
            highlightFollowsCurrentItem: false

            model: menuListModel

            delegate: Item
            {
            height: configurationForm.height*0.1;
            width: parent.width

            Text {
                anchors
                {
                    left: parent.left;
                    leftMargin: 12;
                    verticalCenter: parent.verticalCenter
                }
                color: "white";
                font.pixelSize: (configurationForm.width +
                                 configurationForm.height)/
                                (configurationForm.fontCoefficient*0.6)
                text: menuItemText
            }

            Rectangle
            {
                height: 1;
                width: configurationForm.width*3*configurationForm.barMarginCoefficient;
                color: "gray";
                anchors
                {
                    left: parent.left;
                    bottom: parent.bottom
                }
            }

            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    if(configurationForm.menu_shown)
                    {
                        menuListView.currentIndex = index;
                        nameToTab[menuListModel.get(configurationForm.
                                  previousItemIndex).objectName].visible = false;
                        configurationForm.previousItemIndex = index;
                        nameToTab[menuListModel.get(menuListView.
                                  currentIndex).objectName].visible = true;
                        configurationForm.onMenu();
                    }
                }
            }
        }
    }
}

// this rectangle contains the "normal" view in your app
Rectangle {
    id: normal_view_
    anchors.fill: parent

    // this is what moves the normal view aside
    transform: Translate {
        id: game_translate_
        x: 0
        Behavior on x
        {
            NumberAnimation
            {
                duration: 400;
                easing.type: Easing.OutQuad
            }
        }
    }

    // this is the menu shadow
    BorderImage {
        id: menu_shadow_
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: -10
        z: -1 // this will place it below normal_view_
        visible: configurationForm.menu_shown
        //source: "shadow.png"
        border { left: 12; top: 12; right: 12; bottom: 12 }
    }

    // menu bar and button
    Rectangle {
        id: menu_bar_
        anchors.top: parent.top
        width: parent.width;
        height: configurationForm.height*configurationForm.barMarginCoefficient
        color: "darkGreen"
        Rectangle {
            id: menu_button_
            anchors
            {
                left: parent.left;
                verticalCenter: parent.verticalCenter;
                margins: 16
            }
            color: "darkGreen";
            width: (configurationForm.width +
                    configurationForm.height)/
                   (configurationForm.fontCoefficient*0.8);
            height: (configurationForm.width +
                     configurationForm.height)/
                    (configurationForm.fontCoefficient*0.8);
            smooth: true
            scale: ma_.pressed ? 1.2 : 1

            Text
            {
                anchors.centerIn: parent;
                font.pixelSize: (configurationForm.width +
                                 configurationForm.height)/
                                (configurationForm.fontCoefficient*0.2);
                text: "≡"
                color: "white"
            }
        }

        MouseArea
        {
            id: ma_;
            anchors.fill: parent;
            onClicked: configurationForm.onMenu();
        }
    }

    GeneralConfigurationTab{
        id: generalConfigurationTab
        objectName: "generalConfigurationTab"
        anchors.fill: parent
        anchors.topMargin: configurationForm.height*configurationForm.barMarginCoefficient
        fontCoefficient: fontCoefficient
    }

    MiscConfigurationTab{
        id: miscConfigurationTab
        objectName: "miscConfigurationTab"
        anchors.topMargin: configurationForm.height*configurationForm.barMarginCoefficient
        visible: false
        anchors.fill: parent
    }

    PoeTab{
        id: poeTab
        objectName: "poeTab"
        visible: false
        anchors.topMargin: configurationForm.height*configurationForm.barMarginCoefficient
        anchors.fill: parent
    }

    PortsTab{
        id: portsTab
        objectName: "portsTab"
        visible: false
        anchors.topMargin: configurationForm.height*configurationForm.barMarginCoefficient
        anchors.fill: parent
    }

    WifiTab{
        id: wifiTab
        objectName: "wifiTab"
        visible: false
        anchors.topMargin: configurationForm.height*configurationForm.barMarginCoefficient
        anchors.fill: parent
    }

    VlanSetupTab{
        id: vlanSetupTab
        objectName: "vlanSetupTab"
        visible: false
        anchors.topMargin: configurationForm.height*configurationForm.barMarginCoefficient
        anchors.fill: parent
    }

    CorporationInfoTab{
        id: corporationInfoTab
        objectName: "corporationInfoTab"
        visible: false
        anchors.topMargin: configurationForm.height*configurationForm.barMarginCoefficient
        anchors.fill: parent
    }

    // put this last to "steal" touch on the normal window when menu is shown
    MouseArea {
        anchors.fill: parent
        enabled: configurationForm.menu_shown
        onClicked: configurationForm.onMenu();
    }
}

InfoMessageDialog{id: dialog
}

// this functions toggles the menu and starts the animation
function onMenu()
{
    if (!configurationForm.menu_shown)
    {
        menuListView.currentIndex = configurationForm.previousItemIndex;
    }

    game_translate_.x = configurationForm.menu_shown ? 0 : configurationForm.width * 0.55
    configurationForm.menu_shown = !configurationForm.menu_shown;
}

ListModel
{
    id: menuListModel

    ListElement
    {
        menuItemText: qsTr("menu_general")
        objectName: "menu_general"
    }

    ListElement
    {
        menuItemText: qsTr("menu_misc_config")
        objectName: "menu_misc_config"
    }

    ListElement
    {
        menuItemText: qsTr("menu_poe")
        objectName: "menu_poe"
    }

    ListElement
    {
        menuItemText: qsTr("menu_ports_config")
        objectName: "menu_ports_config"
    }

    ListElement
    {
        menuItemText: qsTr("menu_wifi_config")
        objectName: "menu_wifi_config"
    }

    ListElement
    {
        menuItemText: qsTr("menu_vlan_setup")
        objectName: "menu_vlan_setup"
    }

    ListElement
    {
        menuItemText: qsTr("menu_corporation_info")
        objectName: "menu_corporation_info"
    }
}
}
