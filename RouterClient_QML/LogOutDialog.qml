import QtQuick 2.0

InfoMessageDialog{
    id: logoutDialog

    function doAction()
    {
        socketcontroller.logOutSignal();
    }
}
