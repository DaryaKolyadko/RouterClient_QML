import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.0

FileDialog {
    id: fileDialog
    title: qsTr("bin_file_choose_text")
    folder: shortcuts.home//desktop
    nameFilters: ["Binary files (*.bin)"]

    property string filePath : ""
    property string url: "file:///"

    onAccepted: {
        console.log("You chose: " + fileDialog.fileUrl);
        filePath = fileDialog.fileUrl.toString().slice(url.length);
        doAction();
    }

    onRejected: {
        console.log("Canceled")
    }

    function doAction()
    {
        // should be overrated
    }
}
