import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components" as Components
import "../items_exercise" as ItemsExercise
import "../calendar" as Calendar

Rectangle {
    id: root
    color: "#ecf0f1"

    property string currentSection: "home"
    property int currentUserId: 1  // ID of the currently logged-in user
    property var calendarNoteData: ({})

    // property var calendarNoteData: ({
    //     "2025-02-15": {text: "Leg day", color: "#FF6B6B"},
    //     "2025-02-20": {text: "Cardio", color: "#4ECDC4"},
    //     "2025-02-25": {text: "Break", color: "#F7DC6F"}
    // })

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

    // Add connections with DatabaseManager
    Connections {
        target: DatabaseManager

        // Signals for Exercises
        function onExerciseAdded(success, message) {
            if (success) {
                console.log("Exercise added successfully")
                // Re-loading the exercise list
                if (contentLoader.item && contentLoader.item.refresh) {
                    contentLoader.item.refresh()
                }
            } else {
                console.log("Error when adding exercise:", message)
            }
        }

        function onExerciseDeleted(success, message) {
            if (success) {
                console.log("Exercise deleted successfully")
                // Re-loading the exercise list
                if (contentLoader.item && contentLoader.item.refresh) {
                    contentLoader.item.refresh()
                }
            } else {
                console.log("Error when deleting exercise:", message)
            }
        }

        function onExerciseUpdated(success, message) {
            if (success) {
                console.log("Exercise updated successfully")
                // Re-loading the exercise list
                if (contentLoader.item && contentLoader.item.refresh) {
                    contentLoader.item.refresh()
                }
            } else {
                console.log("Error when updating exercise:", message)
            }
        }

        // Signals for Calendar notes
        function onCalendarNoteSaved(success, message) {
            if (success) {
                console.log("✓ Note saved successfully")
                loadCalendarNotes()
            } else {
                console.log("✗ Error saving note:", message)
            }
        }

        function onCalendarNoteDeleted(success, message) {
            if (success) {
                console.log("✓ Note deleted successfully")
                loadCalendarNotes()
            } else {
                console.log("✗ Error deleting note:", message)
            }
        }

        // Signals for Seance
        function onSeanceAdded(success, message) {
            if (success) {
                console.log("Seance added successfully")
                if (contentLoader.item && contentLoader.item.refresh) {
                    contentLoader.item.refresh()
                }
            }
            else {
                console.log("Error when adding seance:", message)
            }
        }

        function onSeanceDeleted(success, message) {
            if (success) {
                console.log("Seance deleted successfully")
                if (contentLoader.item && contentLoader.item.refresh) {
                    contentLoader.item.refresh()
                }
            }
            else {
                console.log("Error when deleting seance:", message)
            }
        }

        function onSeanceUpdated(success, message) {
            if (success) {
                console.log("Seance updated successfully")
                if (contentLoader.item && contentLoader.item.refresh) {
                    contentLoader.item.refresh()
                }
            }
            else {
                console.log("Error when updating seance:", message)
            }
        }
    }

    // ===== COMPONENTS OF THE CONTENT =====

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
                    text: "🏋 + Add seance"
                    fontSize: root.buttonFontSize
                    buttonRadius: root.buttonRadius
                    normalColor: root.primaryBlue
                    hoverColor: root.hoverBlue
                    pressedColor: root.pressedBlue

                    onClicked: {
                        addSeancePopup.show()
                        console.log("Add seance clicked")
                    }
                }

                Calendar.CalendarWidget {
                    id: calendarWidget
                    Layout.preferredWidth: 350
                    Layout.preferredHeight: 350

                    noteData: root.calendarNoteData

                    onDateClicked: function(date, existingNote, existingColor) {
                        console.log("Date selected:", date)
                        console.log("Existing note:", existingNote)
                        console.log("Existing color:", existingColor)

                        notePopup.show(date, existingNote, existingColor)
                    }

                    onNoteUpdated: function(noteDate, text, color) {}
                }

                // Add exercise button
                Components.GenericButton {
                    Layout.preferredWidth: root.buttonWidth
                    Layout.preferredHeight: root.buttonHeight
                    buttonRadius: 8; fontSize: 18;
                    text: "🏃 + Add exercise"
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
                                text: "🕐"
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

                // Add program button
                Components.GenericButton {
                    Layout.preferredWidth: root.buttonWidth
                    Layout.preferredHeight: root.buttonHeight
                    text: "📋 + Add program"
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
                                text: "🏃"
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

        ItemsExercise.SeanceList {
            id: seanceListComponent
            anchors.fill: parent
            userId: root.currentUserId

            onEditSeance: function(seanceId) {
                console.log("Edit seance:", seanceId)

                // Find the seance data and open the popup in edit mode
                var seances = DatabaseManager.getSeanceByUser(root.currentUserId)
                for (var i = 0; i < seances.length; i++) {
                    if (seances[i].id === seanceId) {
                        addSeancePopup.showEdit(
                            seances[i].id,
                            seances[i].name,
                            seances[i].exerciselist,
                            seances[i].warmup,
                            seances[i].notes
                        )
                        return
                    }
                }
            }

            onDeleteSeance: function(seanceId) {
                console.log("Delete seance:", seanceId)
                DatabaseManager.deleteSeance(seanceId)
            }
        }
    }

    Component {
        id: exerciseContent

        ItemsExercise.ExerciseList {
            id: exerciseListComponent
            anchors.fill: parent
            userId: root.currentUserId

            onEditExercise: function(exerciseId) {
                console.log("Edit exercise:", exerciseId)
                // TODO: Implement exercise edition
            }

            onDeleteExercise: function(exerciseId) {
                console.log("Delete exercise:", exerciseId)
                DatabaseManager.deleteExercise(exerciseId)
            }

            onAddVariationRequested: function(templateId, templateName, firstVariation) {
                console.log("Opening variation editor from ExerciseList for:", templateName)

                // Open AddExercisePopup in edit mode with pre-filled data
                addExercisePopup.calledFromSeance = false  // Not from seance, just creating variation
                addExercisePopup.showForVariation(templateId, templateName, firstVariation)
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
                text: "📋 + Add program"
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

        property bool calledFromSeance: false

        onExerciseAdded: function(name, reps, series, weight, grip, notes) {
            console.log("Adding exercise for userId:", root.currentUserId)
            console.log("data:", name, reps, series, weight, grip, notes)

            if (root.currentUserId <= 0) {
                console.error("Error: userId no valid:", root.currentUserId)
                return
            }

            var newVariationId = -1

            // Check if we're in edit mode (creating variation) or normal mode (creating template + first variation)
            if (addExercisePopup.editMode) {
                // Creating variation for existing template
                console.log("Creating variation for template:", addExercisePopup.templateId)

                newVariationId = DatabaseManager.addExerciseVariation(
                    root.currentUserId,
                    addExercisePopup.templateId,
                    name, reps, series, weight, grip, notes)

                if (newVariationId < 0) {
                    console.error("Failed to create variation")
                    return
                }
                console.log("Variation created with ID:", newVariationId)
            } else {
                // Creating new template + first variation
                console.log("Creating new template + first variation")

                var templateId = DatabaseManager.addExerciseTemplate(root.currentUserId, name)

                if (templateId < 0) {
                    console.error("Failed to create template")
                    return
                }
                console.log("Template created with ID:", templateId)

                newVariationId = DatabaseManager.addExerciseVariation(
                    root.currentUserId,
                    templateId,
                    name, reps, series, weight, grip, notes)

                if (newVariationId < 0) {
                    console.error("Failed to create first variation")
                    return
                }
                console.log("First variation created with ID:", newVariationId)
            }

            // If called from seance, add the variation to the seance
            if (calledFromSeance) {
                calledFromSeance = false
                addSeancePopup.visible = true

                addSeancePopup.addExercise({
                    id: newVariationId,
                    nombre: name,
                    repeticiones: reps,
                    series: series,
                    peso: weight,
                    grip: grip,
                    notas: notes || ""
                })
            }
        }

        onCancelled: {
            // If it was called from the seance, show it again.
            if (calledFromSeance) {
                calledFromSeance = false
                addSeancePopup.visible = true
            }
            console.log("Exercise creation cancelled")
        }
    }

    // Pop-up to add seance
    ItemsExercise.AddSeancePopup {
        id: addSeancePopup
        anchors.fill: parent

        onAddExerciseRequested: {
            // Hide the seance pop-up and open the exercise pop-up.
            addSeancePopup.visible = false
            addExercisePopup.calledFromSeance = true
            addExercisePopup.show()
        }

        onAddExerciseFromListRequested: {
            addSeancePopup.visible = false
            selectExercisePopup.show()
        }

        onSeanceAdded: function(name, exercises, warmUp, notes) {
            console.log("Seance added for userId:", root.currentUserId)
            console.log("data:", name, exercises, warmUp, notes)

            if (root.currentUserId <= 0) {
                console.error("Error: userId not valid:", root.currentUserId)
                return
            }

            // Convert array of IDs to string "1,5,12"
            var exercisesString = exercises.join(",")

            DatabaseManager.addSeance(
                root.currentUserId, name, exercisesString, warmUp, notes )
        }

        onSeanceUpdated: function(seanceId, name, exercises, warmUp, notes) {
            console.log("Seance edited, id:", seanceId)
            console.log("data:", name, exercises, warmUp, notes)

            // Convert array of IDs to string "1,5,12"
            var exercisesString = exercises.join(",")

            DatabaseManager.updateSeance(
                seanceId, name, exercisesString, warmUp, notes )
        }

        onCancelled: {
            console.log("Exercise creation cancelled")
        }
    }

    // Pop-up to add/edit calendar notes
    Calendar.NotePopUp {
        id: notePopup
        anchors.fill: parent

        onNoteSaved: function(noteDate, text, color) {
                    var dateStr = getDateString(noteDate)

                    if (text.trim() === "") {
                        // Texto vacío = eliminar nota
                        DatabaseManager.deleteCalendarNote(root.currentUserId, dateStr)
                    } else {
                        // Guardar en BD (onCalendarNoteSaved recargará la vista)
                        DatabaseManager.saveCalendarNote(root.currentUserId, dateStr, text, color)
                    }
                }

        onCancelled: {
            console.log("Note creation cancelled")
        }
    }

    // Pop-up to select exercise from list
    ItemsExercise.SelectExercisePopup {
        id: selectExercisePopup
        anchors.fill: parent
        userId: root.currentUserId

        // Legacy signal handler (kept for compatibility)
        onExerciseSelected: function(exercise) {
            addSeancePopup.visible = true
            addSeancePopup.addExercise(exercise)
        }

        // New handler: Template selected, open AddExercisePopup in edit mode
        onTemplateSelectedForVariation: function(templateId, templateName, firstVariation) {
            console.log("Opening variation editor for template:", templateName)

            // Open AddExercisePopup in edit mode with pre-filled data
            addExercisePopup.calledFromSeance = true
            addExercisePopup.showForVariation(templateId, templateName, firstVariation)
        }

        onCancelled: {
            addSeancePopup.visible = true
        }
    }

    Component.onCompleted: {
           loadCalendarNotes()
       }

    // NUEVA FUNCIÓN: Cargar notas desde BD y actualizar el calendario
    function loadCalendarNotes() {
        var notes = DatabaseManager.getCalendarNotesByUser(root.currentUserId)
        root.calendarNoteData = notes
        console.log("Calendar notes loaded:", JSON.stringify(notes))
    }

    function getDateString(date) {
        var year = date.getFullYear()
        var month = (date.getMonth() + 1).toString().padStart(2, '0')
        var day = date.getDate().toString().padStart(2, '0')
        return year + "-" + month + "-" + day
    }
}
