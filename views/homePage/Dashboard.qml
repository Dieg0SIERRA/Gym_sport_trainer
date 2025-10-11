import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components" as Components

Rectangle {
    id: root
    color: "#ecf0f1"

    property string currentSection: "home"

    // ===== Constants for graphic design =====
    readonly property color primaryBlue: "#1E90FF"
    readonly property color hoverBlue: "#4169E1"
    readonly property color pressedBlue: "#0066CC"
    readonly property color darkText: "#2c3e50"
    readonly property color lightText: "#95a5a6"
    readonly property color cardBackground: "white"
    readonly property color cardBorder: "#e0e0e0"

    readonly property int buttonWidth: 250
    readonly property int buttonHeight: 80
    readonly property int cardWidth: 250
    readonly property int cardHeight: 120
    readonly property int gridSpacing: 20
    readonly property int buttonRadius: 20
    readonly property int cardRadius: 20
    readonly property int buttonFontSize: 18
    readonly property int cardValueSize: 28
    readonly property int cardLabelSize: 16
    readonly property int cardEmojiSize: 32

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
                default:         return homeContent
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

        Item {
            anchors.fill: parent

            GridLayout {
                anchors.centerIn: parent
                columns: 2
                rowSpacing: root.gridSpacing
                columnSpacing: root.gridSpacing

                // Botón Add seance
                Components.GenericButton {
                    Layout.preferredWidth: root.buttonWidth
                    Layout.preferredHeight: root.buttonHeight
                    text: "+ Add seance"
                    fontSize: root.buttonFontSize
                    buttonRadius: root.buttonRadius
                    normalColor: root.primaryBlue
                    hoverColor: root.hoverBlue
                    pressedColor: root.pressedBlue

                    onClicked: {
                        console.log("Add seance clicked")
                    }
                }

                // Card Calendar
                Rectangle {
                    Layout.preferredWidth: root.cardWidth
                    Layout.preferredHeight: root.cardHeight
                    radius: root.cardRadius
                    color: root.cardBackground
                    border.color: root.cardBorder
                    border.width: 1

                    Row {
                        anchors.centerIn: parent
                        spacing: 15

                        Text {
                            text: "??"
                            font.pixelSize: 40
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "Calendar"
                            font.pixelSize: 24
                            font.weight: Font.Bold
                            color: root.darkText
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }

                // Botón Add exercise
                Components.GenericButton {
                    Layout.preferredWidth: root.buttonWidth
                    Layout.preferredHeight: root.buttonHeight
                    text: "+ Add exercise"
                    fontSize: root.buttonFontSize
                    buttonRadius: root.buttonRadius
                    normalColor: root.primaryBlue
                    hoverColor: root.hoverBlue
                    pressedColor: root.pressedBlue

                    onClicked: {
                        console.log("Add exercise clicked")
                    }
                }

                // Card Time in gym
                Rectangle {
                    Layout.preferredWidth: root.cardWidth
                    Layout.preferredHeight: root.cardHeight
                    radius: root.cardRadius
                    color: root.cardBackground
                    border.color: root.cardBorder
                    border.width: 1

                    Column {
                        anchors.centerIn: parent
                        spacing: 8

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 10

                            Text {
                                text: "??"
                                font.pixelSize: root.cardEmojiSize
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: "3h 20min"
                                font.pixelSize: root.cardValueSize
                                font.weight: Font.Bold
                                color: root.darkText
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Text {
                            text: "Time in gym"
                            font.pixelSize: root.cardLabelSize
                            color: root.lightText
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                // Botón Add program
                Components.GenericButton {
                    Layout.preferredWidth: root.buttonWidth
                    Layout.preferredHeight: root.buttonHeight
                    text: "?? Add program"
                    fontSize: root.buttonFontSize
                    buttonRadius: root.buttonRadius
                    normalColor: root.primaryBlue
                    hoverColor: root.hoverBlue
                    pressedColor: root.pressedBlue

                    onClicked: {
                        console.log("Add program clicked")
                    }
                }

                // Card Time running
                Rectangle {
                    Layout.preferredWidth: root.cardWidth
                    Layout.preferredHeight: root.cardHeight
                    radius: root.cardRadius
                    color: root.cardBackground
                    border.color: root.cardBorder
                    border.width: 1

                    Column {
                        anchors.centerIn: parent
                        spacing: 8

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 10

                            Text {
                                text: "??"
                                font.pixelSize: root.cardEmojiSize
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: "12 km"
                                font.pixelSize: root.cardValueSize
                                font.weight: Font.Bold
                                color: root.darkText
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Text {
                            text: "Time running"
                            font.pixelSize: root.cardLabelSize
                            color: root.lightText
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
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
