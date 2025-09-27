import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "views"


ApplicationWindow {
    id: window
    visible: true
    width: 1024
    height: 768
    title: "Exercise Tracker"

    property string appState: "login"

    // Main container for views
    Loader {
        id: mainLoader
        anchors.fill: parent

        sourceComponent: appState === "login" ? loginPage : homePage
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
