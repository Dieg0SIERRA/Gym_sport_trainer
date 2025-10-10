import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components" as Components

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
                rowSpacing: 20
                columnSpacing: 20

                // Botón Add seance
                Components.GenericButton {
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 80
                    text: "+ Add seance"
                    fontSize: 18
                    buttonRadius: 20
                    normalColor: "#1E90FF"
                    hoverColor: "#4169E1"
                    pressedColor: "#0066CC"

                    onClicked: {
                        console.log("Add seance clicked")
                    }
                }

                // Card Calendar
                Rectangle {
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 120
                    radius: 20
                    color: "white"
                    border.color: "#e0e0e0"
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
                            color: "#2c3e50"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }

                // Botón Add exercise
                Components.GenericButton {
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 80
                    text: "+ Add exercise"
                    fontSize: 18
                    buttonRadius: 20
                    normalColor: "#1E90FF"
                    hoverColor: "#4169E1"
                    pressedColor: "#0066CC"

                    onClicked: {
                        console.log("Add exercise clicked")
                    }
                }

                // Card Time in gym
                Rectangle {
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 120
                    radius: 20
                    color: "white"
                    border.color: "#e0e0e0"
                    border.width: 1

                    Column {
                        anchors.centerIn: parent
                        spacing: 8

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 10

                            Text {
                                text: "??"
                                font.pixelSize: 32
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: "3h 20min"
                                font.pixelSize: 28
                                font.weight: Font.Bold
                                color: "#2c3e50"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Text {
                            text: "Time in gym"
                            font.pixelSize: 16
                            color: "#95a5a6"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                // Botón Add program
                Components.GenericButton {
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 80
                    text: "?? Add program"
                    fontSize: 18
                    buttonRadius: 20
                    normalColor: "#1E90FF"
                    hoverColor: "#4169E1"
                    pressedColor: "#0066CC"

                    onClicked: {
                        console.log("Add program clicked")
                    }
                }

                // Card Time running
                Rectangle {
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 120
                    radius: 20
                    color: "white"
                    border.color: "#e0e0e0"
                    border.width: 1

                    Column {
                        anchors.centerIn: parent
                        spacing: 8

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 10

                            Text {
                                text: "??"
                                font.pixelSize: 32
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: "12 km"
                                font.pixelSize: 28
                                font.weight: Font.Bold
                                color: "#2c3e50"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Text {
                            text: "Time running"
                            font.pixelSize: 16
                            color: "#95a5a6"
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
