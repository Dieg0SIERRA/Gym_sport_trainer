import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "views/login" as Login
import "views/homePage" as HomePage


ApplicationWindow {
    id: window
    visible: true
    width: 1024
    height: 768
    title: "Exercise Tracker"

    property string appState: "login"

    // Property to store user ID
    property int currentUserId: -1
    property string currentUsername: ""

    // Main container for views
    Loader {
        id: mainLoader
        anchors.fill: parent

        sourceComponent: appState === "login" ? loginPage : homePage

        // giving user ID to component
        onLoaded: {
            if (appState === "home" && item) {
                item.currentUserId = window.currentUserId
                item.currentUsername = window.currentUsername
            }
        }
    }

    // --- Login Page ---
    Component {
        id: loginPage
        Login.LoginView {
            onLoginSuccess: {
                // if login successful change to "home"
                window.appState = "home"
            }
        }
    }

    // --- Home Page ---
    Component {
        id: homePage
        HomePage.HomePageView { }
    }
}
