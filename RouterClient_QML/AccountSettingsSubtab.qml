import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab{
    id: accountSettingsSubtabId
    active: true
    title: qsTr("account_settings")

    property int bottomMargin: 15//resolution.dp(15) //15
    property int fontCoefficient: 100//resolution.dp(100) // 100
    property string newPasswordStr: "NewPassword"
    property var regexLogin: /\b(?:(?:[a-zA-Z0-9_.]?)){3,15}\b/
    property var regexPassword: /\b(?:(?:[a-zA-Z0-9_.]?)){3,15}\b/

    Connections {
        target: socketcontroller
    }

    GridLayout{
        id: accountSettingsGrid
        columns: 3
        anchors.fill: parent

        InfoMessageDialog {
            id: accountSettingsMessageDialog
        }

        InfoMessageDialog {
            id: savePasswordMessageDialog

            function doAction()
            {
                socketcontroller.logOut();
            }
        }

        ErrorInfoDialog {
            id: accountSettingsErrorDialog
        }

        Button{
            id: changeAccountSettings
            text: qsTr("change_password")
            Layout.columnSpan: 3
            Layout.fillWidth: true
            anchors.bottomMargin: bottomMargin

            onClicked: {
                if (newPasswordTextInput.text === confirmPasswordTextInput.text)
                {
                    if(checkNewPassword(newPasswordStr, oldPasswordTextInput.text,
                                        newPasswordTextInput.text))
                    {
                        setNewPassword(newPasswordStr, oldPasswordTextInput.text,
                                       newPasswordTextInput.text);
                        savePasswordMessageDialog.show(qsTr("password_saved_relogin"));
                    }
                    else
                    {
                        accountSettingsErrorDialog.show(qsTr("wrong_password"));
                    }
                }
                else
                {
                    accountSettingsErrorDialog.show(qsTr("different_passwords"));
                }
            }

            function checkNewPassword(paramName, oldPassword, newPassword)
            {
                var res = socketcontroller.permitSetNewPassword(paramName, oldPassword,
                                                                newPassword);
                if(res === 1)
                    return true;
                else if (res === 0)
                    accountSettingsMessageDialog.show(qsTr("new_password_wrong"));
                else //new
                    accountSettingsErrorDialog.show(qsTr("connection_lost"));
                return false;
            }

            function setNewPassword(paramName, oldPassword, newPassword)
            {
                    var res = socketcontroller.setNewPassword(paramName, oldPassword,
                                                              newPassword);
                    if(res === 1)
                        return true;
                    return false;
            }
        }

        GridLayout {
            id: accountSettingsGridLayout
            columns: 3
            anchors.centerIn: parent
            Layout.fillWidth: true

            Text{
                id: loginText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("login")
            }

            TextField {
                id: loginTextInput
                objectName: "accountSettingsLoginTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                enabled: false
                style: MyTextFieldStyle{id: loginfield}
                validator: RegExpValidator{
                    regExp: regexLogin
                }
            }

            Text{
                id:oldPasswordText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("old_password")
            }

            TextField {
                id: oldPasswordTextInput
                objectName: "oldPasswordTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                //text: "123abc" //delete
                style: MyTextFieldStyle{id: oldpasswordield}
                validator: RegExpValidator{
                    regExp: regexPassword
                }
                echoMode: TextInput.Password
            }

            Text{
                id:newPasswordText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("new_password")
            }

            TextField {
                id: newPasswordTextInput
                objectName: "newPasswordTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                //text: "123456" //delete
                style: MyTextFieldStyle{id: newpasswordfield}
                validator: RegExpValidator{
                    regExp: regexPassword
                }
                echoMode: TextInput.Password
            }

            Text{
                id: confirmPasswordText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("confirm_password")
            }

            TextField {
                id: confirmPasswordTextInput
                objectName: "confirmPasswordTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                //text: "123456" //delete
                style: MyTextFieldStyle{id: confirmpasswordfield}
                validator: RegExpValidator{
                    regExp: regexPassword
                }
                echoMode: TextInput.Password
            }
        }
    }
}
