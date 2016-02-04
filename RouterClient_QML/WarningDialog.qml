import QtQuick 2.0
import QtQuick.Dialogs 1.2

Item {
    MessageDialog {
        id: messageDialog
        title: qsTr("warning")
        icon: StandardIcon.Warning
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        onAccepted: {
            //TODO
            console.debug("ohh yes")
        }
    }

    function show(caption)
    {
        messageDialog.text = caption;
        messageDialog.open();
    }
}
