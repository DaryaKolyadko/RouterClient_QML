import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4


Item {
    id: loginForm
    property string login: ""
    property bool errorOccurred: false
    property int bottomMargin: resolution.dp(10) //10
    property int fontCoefficient: resolution.dp(60)//70
    property var regexLogin: /\b(?:(?:[a-zA-Z0-9_.]?)){3,15}\b/
    property var regexPassword: /\b(?:(?:[a-zA-Z0-9_.]?)){3,15}\b/
    property var regexHostAddress: /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/

    function setLogin(loginName)
    {
        login = loginName;
    }


    InfoMessageDialog{
        id: loginFormMessageDialog
    }

    Connections{
        target: socketcontroller
        onSendErrorMessage:{
            errorOccurred = true;
            loginFormMessageDialog.show(message);
        }
    }

       GridLayout {
           id: gridLayoutLoginForm
           columns: 3
           anchors.centerIn: parent

           Text{
               id: loginText
               font.bold: true
               font.letterSpacing: 1
               font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
               Layout.fillWidth: true
               Layout.fillHeight: true
               anchors.bottomMargin: bottomMargin
               text: qsTr("login")
           }

           TextField {
               id: loginTextInput
               objectName: "loginTextInput"
               font.letterSpacing: 1
               text: "admin" //delete
               font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
               Layout.columnSpan: 2
               Layout.fillWidth: true
               Layout.fillHeight: true
               anchors.bottomMargin: bottomMargin
               style: MyTextFieldStyle{id: loginfield}
               validator: RegExpValidator{
                   regExp: regexLogin
               }
           }

           Text{
               id: passwordText
               font.bold: true
               font.letterSpacing: 1
               font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
               Layout.fillWidth: true
               Layout.fillHeight: true
               anchors.bottomMargin: bottomMargin
               text: qsTr("password")
           }

           TextField {
               id: passwordTextInput
               objectName: "passwordTextInput"
               font.letterSpacing: 1
               font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
               Layout.columnSpan: 2
               Layout.fillWidth: true
               Layout.fillHeight: true
               style: MyTextFieldStyle{id: passwordfield}
               anchors.bottomMargin: bottomMargin
               validator: RegExpValidator{
                   regExp: regexPassword
               }
               echoMode: TextInput.Password
               text: "123abc" // delete
           }

           Text{
               id: hostAddressText
               font.bold: true
               font.letterSpacing: 1
               font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
               Layout.fillWidth: true
               Layout.fillHeight: true
               anchors.bottomMargin: bottomMargin
               text: qsTr("host_address")
           }

           TextField {
               id: hostAddressTextInput
               objectName: "hostAddressTextInput"
               font.letterSpacing: 1
               font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
               Layout.columnSpan: 2
               Layout.fillWidth: true
               Layout.fillHeight: true
               style: MyTextFieldStyle{id: hostfield}
               anchors.bottomMargin: bottomMargin
               // text: "10.160.14.241" // delete
               validator: RegExpValidator{
                   regExp: regexHostAddress
               }
           }

           Button {
               id: loginInButton
               text: qsTr("log_in")
               Layout.columnSpan: 3
               Layout.fillWidth: true

               onClicked: {
                   setLogin(loginTextInput.text);
                   socketcontroller.initConnection();

                   if(!errorOccurred) {
                       var result = socketcontroller.confirmLoginAndPassword(loginTextInput.text,
                                                                             passwordTextInput.text);
                       console.debug(result);
                       if(result == 1) {
                           socketcontroller.recieveLoginClick();
                           loginForm.visible = false;
                           console.debug("vse ok");
                       }
                       else {
                           console.debug("vse ploho, ti dodik");
                       }
                   }
                   else
                       errorOccurred = !errorOccurred;
               }
           }
       }

       ResolutionController{
           id: resolution
       }
}
