import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components" as Components
import "../items_exercise" as ItemsExercise

Rectangle {
    id: root
    color: "#ecf0f1"

    property string currentSection: "home"
    property int currentUserId: 1  // ID of the currently logged-in user

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

    // Add connections with DatabaseManager for exercises
    Connections {
        target: DatabaseManager

        function onExerciseAdded(success, message) {
            if (success) {
                console.log("? Ejercicio agregado exitosamente")
                // Re-loading the exercise list
                if (contentLoader.item && contentLoader.item.refresh) {
                    contentLoader.item.refresh()
                }
            } else {
                console.log("? Error al agregar ejercicio:", message)
            }
        }

        function onExerciseDeleted(success, message) {
            if (success) {
                console.log("? Ejercicio eliminado exitosamente")
                // Re-loading the exercise list
                if (contentLoader.item && contentLoader.item.refresh) {
                    contentLoader.item.refresh()
                }
            } else {
                console.log("? Error al eliminar ejercicio:", message)
            }
        }

        function onExerciseUpdated(success, message) {
            if (success) {
                console.log("? Ejercicio actualizado exitosamente")
                // Re-loading the exercise list
                if (contentLoader.item && contentLoader.item.refresh) {
                    contentLoader.item.refresh()
                }
            } else {
                console.log("? Error al actualizar ejercicio:", message)
            }
        }
    }

    // ===== COMPONENTES DE CONTENIDO =====

    Component {
        id: homeContent

        Item {
            anchors.fill: parent

            GridLayout {
                anchors.centerIn: parent
                columns: 2
                rowSpacing: root.gridSpacing
                columnSpacing: root.gridSpacing

                // Button Add seance
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

                // calender widget
                CalendarWidget {
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 200
                    highlightedDates: ["2025-10-15", "2025-10-20", "2025-10-25"]
                    notes: {
                        "2025-10-15": "Leg day",
                        "2025-10-20": "Cardio",
                        "2025-10-25": "Break"
                    }
                    onDateClicked: function(date) {
                        console.log("Fecha seleccionada:", date)
                    }
                }

                // Add exercise button
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
                    	addExercisePopup.show()
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

            Components.GenericButton {
                width: 200; height: 50; buttonRadius: 14; fontSize: 18;
                Layout.preferredWidth: root.buttonWidth
                Layout.preferredHeight: root.buttonHeight
                text: "?? + Add seance"
                normalColor: root.primaryBlue
                hoverColor: root.hoverBlue
                pressedColor: root.pressedBlue

                onClicked: {
                    console.log("Add seance clicked")
                }
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

            Components.GenericButton {
                width: 200; height: 50; buttonRadius: 14; fontSize: 18;
                Layout.preferredWidth: root.buttonWidth
                Layout.preferredHeight: root.buttonHeight
                text: "?? + Add exercise"
                normalColor: root.primaryBlue
                hoverColor: root.hoverBlue
                pressedColor: root.pressedBlue

                onClicked: {
                	addExercisePopup.show()
                    console.log("Add exercise clicked")
                }
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

            Components.GenericButton {
                width: 200; height: 50; buttonRadius: 14; fontSize: 18;
                Layout.preferredWidth: root.buttonWidth
                Layout.preferredHeight: root.buttonHeight
                text: "?? + Add program"
                normalColor: root.primaryBlue
                hoverColor: root.hoverBlue
                pressedColor: root.pressedBlue

                onClicked: {
                    console.log("Add program clicked")
                }
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

    // Pop-up to add exercise
    ItemsExercise.AddExercisePopup {
        id: addExercisePopup
        anchors.fill: parent

        onExerciseAdded: function(name, reps, series, weight, grip, notes) {
            console.log("Exercise added:", name, reps, series, weight, grip, notes)
            
            // Validate that we have a valid userId
            if (root.currentUserId <= 0) {
                console.error("Error: userId no válido:", root.currentUserId)
                return
            }
            
            // Call DatabaseManager to save the exercise
            DatabaseManager.addExercise(
                root.currentUserId,
                name,
                reps,
                series,
                weight,
                grip,
                notes
            )
        }

        onCancelled: {
            console.log("Exercise creation cancelled")
        }
    }
}
