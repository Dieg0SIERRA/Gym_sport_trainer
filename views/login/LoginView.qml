import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components" as Components

Item {
    id: root
    signal loginSuccess()
    property string currentView: "menu"     // values: "menu", "login", "create"

    Image {
        id: backgroundImage
        anchors.fill: parent
        //source: "qrc:/views/assets/login_image.jpg"
        source: "file:///C:/Users/.../views/assets/login_image.jpg"
        fillMode: Image.PreserveAspectCrop
    }

    // --- Start screen with 2 buttons ---
    Column {
        id: startMenu
        anchors.centerIn: parent
        spacing: 20
        visible: root.currentView === "menu"

        Components.GenericButton {
            width: 200; height: 50; buttonRadius: 14; fontSize: 18;
            text: "Login"
            onClicked: root.currentView = "login"
        }

        Components.GenericButton {
            width: 200; height: 50; buttonRadius: 14; fontSize: 18;
            text: "Create Account"
            onClicked: root.currentView = "create"
        }
    }

    // --- Create Account ---
    Rectangle {
        id: createContainer
        width: 380
        height: 600
        radius: 20
        anchors.centerIn: parent
        color: Qt.rgba(30/255, 30/255, 30/255, 0.85)
        visible: root.currentView === "create"

        ColumnLayout {
            anchors.centerIn: parent
            width: parent.width - 60
            spacing: 20

            // Logo & Title
            LogoTitle {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: 80

                titleText: "Create Account"
                iconText: "💪"
            }

            // Username field
            Components.GenericTextField {
                id: usernameField
                Layout.fillWidth: true
                Layout.preferredHeight: 85

                labelFontSize:14
                labelText: "Username"
                placeholderText: "Enter username"
                isValid: isUsernameValid

                onTextChanged: validateUsername()

                validationMessage: usernameField.text.length === 0 ? "" :
                        isUsernameValid ? "✓ Username available" :
                            "✗ Username must be unique, at least 5 characters. \n\t Only the special characters ´. - _´ are availables "
                showValidation: usernameField.text.length > 0
            }

            // Password field
            Components.GenericTextField {
                id: passwordField
                Layout.fillWidth: true
                Layout.preferredHeight: 85

                labelFontSize:14
                labelText: "Password"
                placeholderText: "Enter password"
                isPassword: true

                onTextChanged: {
                    validatePassword()
                    validateConfirmPassword()
                }

                isValid: isPasswordValid
                validationMessage: usernameField.text.length === 0 ? "" :
                        isPasswordValid ? "✓ Strong password" : "✗ Must include: A-Z, a-z, 0-9, special chars"
                showValidation: usernameField.text.length > 0
            }

            // Confirm Password field
            Components.GenericTextField {
                id: confirmPasswordField
                Layout.fillWidth: true
                Layout.preferredHeight: 85

                labelFontSize:14
                labelText: "Confirm Password"
                placeholderText: "Confirm Password"
                isPassword: true

                onTextChanged: validateConfirmPassword()

                isValid: isConfirmPasswordValid
                validationMessage: confirmPasswordField.text.length === 0 ? "" :
                        isConfirmPasswordValid ? "✓ Passwords match" : "✗ Passwords don't match"
                showValidation: usernameField.text.length > 0
            }

            // Create Account button
            Components.GenericButton {
                id: createAccountButton
                Layout.fillWidth: true
                Layout.preferredHeight: 55
                Layout.topMargin: 15

                width: 200; height: 50; buttonRadius: 14; fontSize: 18;
                enabled: isUsernameValid && isPasswordValid && isConfirmPasswordValid
                text: "Create Account"
                onClicked: handleAccountCreation()
            }
        }
    }

    // login field

}
