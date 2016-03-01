import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.0

FileDialog {
    id: fileDialog
    title: qsTr("bin_file_choose_text")
    folder: shortcuts.desktop
    nameFilters: ["Binary files (*.bin)"]

    onAccepted: {
        console.log("You chose: " + fileDialog.fileUrls)
    }

    onRejected: {
        console.log("Canceled")
    }
}
