import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    color: "#ecf0f1"

    property string currentSection: "home"

    // Charging content dynamically depending on section
    Loader {
        id: contentLoader
        anchors.fill: parent
        anchors.margins: 20

        sourceComponent: {
            switch(root.currentSection) {
                case "home":     return homeContent
                case "seance":   return seanceContent
                case "exercise": return exerciseContent
                case "program":  return programContent
                case "stats":    return statsContent
                default:         return homeContentn
            }
        }

        // transition when changing of content
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        onSourceComponentChanged: {
            opacity = 0
            opacity = 1
        }
    }

    // ===== definition of each component =====

    Component {
        id: homeContent

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "HOME"
                font.pixelSize: 32
                font.weight: Font.Bold
                color: "#2c3e50"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Welcome to dashboard"
                font.pixelSize: 16
                color: "#7f8c8d"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Component {
        id: seanceContent

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "SEANCE"
                font.pixelSize: 32
                font.weight: Font.Bold
                color: "#2c3e50"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Training sessions management"
                font.pixelSize: 16
                color: "#7f8c8d"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Component {
        id: exerciseContent

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "EXERCISE"
                font.pixelSize: 32
                font.weight: Font.Bold
                color: "#2c3e50"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Library of exercises"
                font.pixelSize: 16
                color: "#7f8c8d"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Component {
        id: programContent

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "PROGRAMMES"
                font.pixelSize: 32
                font.weight: Font.Bold
                color: "#2c3e50"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Training programmes"
                font.pixelSize: 16
                color: "#7f8c8d"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Component {
        id: statsContent

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "STATS"
                font.pixelSize: 32
                font.weight: Font.Bold
                color: "#2c3e50"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Statistics & Progress"
                font.pixelSize: 16
                color: "#7f8c8d"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
