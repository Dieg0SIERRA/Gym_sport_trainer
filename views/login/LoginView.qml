import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components" as Components

Item {
    id: root
    signal loginSuccess()
    property string currentView: "menu"     // values: "menu", "login", "create"
    // signal navigateToHomepage()  // Nueva señal

    // Validation properties
    property bool isUsernameValid: false
    property bool isPasswordValid: false
    property bool isConfirmPasswordValid: false
    property bool showSuccessPopup: false

    Image {
        id: backgroundImage
        anchors.fill: parent
        //source: "qrc:/views/assets/login_image.jpg"
        source: "file:///C:/Users/.../views/assets/login_image.jpg"
        fillMode: Image.PreserveAspectCrop
    }

    // Pop-up accout created successfully
    Rectangle {
        id: successPopup
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.7)
        visible: showSuccessPopup
        z: 1000

        Rectangle {
            width: 300
            height: 200
            anchors.centerIn: parent
            color: "#2a2a2a"
            radius: 15
            border.width: 2
            border.color: "#6C63FF"

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "✓"
                    color: "#40a040"
                    font.pixelSize: 40
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Account created successfully!"
                    color: "#ffffff"
                    font.pixelSize: 16
                    font.weight: Font.Medium
                }

                // OK Button
                Components.GenericButton {
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 40
                    Layout.alignment: Qt.AlignHCenter

                    width: 200; height: 50; buttonRadius: 8; fontSize: 18;
                    text: "OK"
                    onClicked: {
                        showSuccessPopup = false
                        // Limpiar campos
                        usernameField.text = ""
                        passwordField.text = ""
                        confirmPasswordField.text = ""
                        navigateToHomepage()
                    }
                }
            }
        }
    }

    // --- Start screen with buttons ---
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
    // --- Login Account ---
    Rectangle {
        id: loginContainer
        width: 380
        height: 500
        radius: 20
        anchors.centerIn: parent
        color: Qt.rgba(30/255, 30/255, 30/255, 0.85)
        visible: root.currentView === "login"

        ColumnLayout {
            anchors.centerIn: parent
            width: parent.width - 60
            spacing: 25

            // Back button
            Components.GenericButton {
                Layout.alignment: Qt.AlignLeft
                width: 80; height: 35; fontSize: 14; buttonRadius: 8
                text: " Back"

                onClicked: {
                    root.currentView = "menu"
                    // Cleaning fields
                    usernameField.text = ""
                    passwordField.text = ""
                    confirmPasswordField.text = ""
                }
            }

            // Logo/Title
            LogoTitle {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: 80

                titleText: "Exercise Tracker"
                iconText: "💪"
            }

            // User field
            Components.GenericTextField {
                id: userField
                Layout.fillWidth: true
                Layout.preferredHeight: 70

                labelFontSize:14
                labelText: "User"
                placeholderText: "Enter User"
            }

            // Password field
            Components.GenericTextField {
                id: passField
                Layout.fillWidth: true
                Layout.preferredHeight: 70

                labelFontSize:14
                labelText: "Password"
                placeholderText: "Enter Password"
            }

            // Login button
            Components.GenericButton {
                id: loginButton
                Layout.fillWidth: true
                Layout.preferredHeight: 55
                Layout.topMargin: 15

                width: 200; height: 50; buttonRadius: 14; fontSize: 18
                text: "Login"
                // enabled:

                onClicked: {
                    if (userField.text.trim() !== "" && passwordField.text.trim() !== "")
                        loginSuccess()
                }
            }
        }
    }

    // Validation functions
    function validateUsername() {
        var username = usernameField.text
        // Regex: solo letras, números, punto, guión bajo, guión medio
        var validFormat = /^[a-zA-Z0-9._-]+$/.test(username)
        var hasMinLength = username.length >= 5

        isUsernameValid = validFormat && hasMinLength
    }

    function validatePassword() {
        var password = passwordField.text
        var hasUpper = /[A-Z]/.test(password)
        var hasLower = /[a-z]/.test(password)
        var hasNumber = /[0-9]/.test(password)
        var hasSpecial = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)
        var hasMinLength = password.length >= 8

        isPasswordValid = hasUpper && hasLower && hasNumber && hasSpecial && hasMinLength
    }

    function validateConfirmPassword() {
        isConfirmPasswordValid = confirmPasswordField.text === passwordField.text &&
                               confirmPasswordField.text.length > 0
    }

    function showSuccessPopup() {
        showSuccessPopup = true
    }

    // Función para manejar la creación de cuenta
    function handleAccountCreation() {
        console.log("Creating account for:", usernameField.text)
        // Aquí se conectará con SQLite después

        // Mostrar popup de éxito
        showSuccessPopup = true
    }

    function navigateToHomepage() {
        root.loginSuccess()  // Emite la señal hacia Main.qml
    }
}
