import QtQuick 2.0
import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4

Item {
    id: configurationForm
    visible: true
    width: 800
    height: 400

    property int bottomMargin: 15
    property int fontCoefficient: 100

    TabView{
        id: tabView
        objectName: "tabView"
        anchors.fill: parent

        GeneralConfigurationTab{
            id: generalConfigurationTab
            objectName: "generalConfigurationTab"
            active: true
            anchors.fill: parent
            fontCoefficient: fontCoefficient         
        }

        WifiConfigurationTab{
            id: wifiConfigurationTab
            objectName: "wifiConfigurationTab"
            anchors.fill: parent
            bottomMargin: bottomMargin
        }

        SystemInformationTab{
            id: systemInformationTab
            objectName: "systemInformationTab"
            anchors.fill: parent
        }
    }
}
