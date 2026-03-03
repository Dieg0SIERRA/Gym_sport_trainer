import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "../components" as Components

Rectangle {
    id: root
    anchors.fill: parent
    color: Qt.rgba(0, 0, 0, 0.7)
    visible: false
    z: 1000

    signal seanceAdded(string name, var exercises, string warmUp, string notes)
    signal addExerciseRequested()
    signal addExerciseFromListRequested()
    signal cancelled()

    // ── Edit mode properties ──
    property bool editMode: false
    property int editSeanceId: -1
    signal seanceUpdated(int seanceId, string name, var exercises, string warmUp, string notes)


    ListModel {
        id: exercisesModel
        // Model will contain: { id, nombre, repeticiones, series, peso, grip, notas }
    }

    // Close pop-up when clicking outside
    MouseArea {
        anchors.fill: parent
        onClicked: root.visible = false
    }

    // Main container
    Rectangle {
        id: formContainer
        width: 600
        height: Math.min(contentColumn.implicitHeight + 60, parent.height * 0.9)
        anchors.centerIn: parent
        color: "#2a2a2a"
        radius: 20
        border.width: 2
        border.color: "#6C63FF"

        // Prevent the click from closing the pop-up
        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: 30
            spacing: 15

            // Title
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: root.editMode ? "✏️ Edit Seance" : "🏋️ Add New Seance"
                color: "#ffffff"
                font.pixelSize: 24
                font.weight: Font.Bold
            }

            // Separator line
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 2
                color: "#6C63FF"
                opacity: 0.3
            }

            // Grid with fields
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 2
                rowSpacing: 15
                columnSpacing: 15

                // Seance Name
                Components.GenericTextField {
                    id: seanceNameField
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    labelText: "Seance Name"
                    placeholderText: "e.g., Push seance"
                    fieldBackgroundColor: "#1a1a1a"
                    fieldRadius: 8
                    fontSize: 14
                    labelFontSize: 14
                }

                // Warm-up exercise
                Text {
                    text: "Warm-up exercise"
                    color: "#b0b0b0"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    color: "#1a1a1a"
                    radius: 8
                    border.width: warmUpExercise.pressed ? 2 : 1
                    border.color: warmUpExercise.pressed ? "#6C63FF" : "#404040"

                    ComboBox {
                        id: warmUpExercise
                        anchors.fill: parent
                        anchors.margins: 1

                        model: ["-------", "Running", "Cycling", "Elliptical ", "Stretching", "Nothing"]

                        background: Rectangle {
                            color: warmUpExercise.pressed ? "#3a3a3a" : "#1a1a1a"
                            radius: 8
                        }

                        contentItem: Text {
                            leftPadding: 10
                            text: warmUpExercise.displayText
                            color: "#ffffff"
                            font.pixelSize: 14
                            verticalAlignment: Text.AlignVCenter
                        }

                        indicator: Text {
                            x: warmUpExercise.width - width - 10
                            y: warmUpExercise.height / 2 - height / 2
                            text: "▼"
                            color: "#6C63FF"
                            font.pixelSize: 12
                        }

                        popup: Popup {
                            y: warmUpExercise.height + 2
                            width: warmUpExercise.width
                            padding: 1

                            contentItem: ListView {
                                clip: true
                                implicitHeight: contentHeight
                                model: warmUpExercise.popup.visible ? warmUpExercise.delegateModel : null
                                currentIndex: warmUpExercise.highlightedIndex

                                ScrollIndicator.vertical: ScrollIndicator {}
                            }

                            background: Rectangle {
                                color: "#2a2a2a"
                                border.color: "#6C63FF"
                                border.width: 1
                                radius: 8
                            }
                        }

                        delegate: ItemDelegate {
                            width: warmUpExercise.width
                            contentItem: Text {
                                text: modelData
                                color: "#ffffff"
                                font.pixelSize: 14
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 10
                            }
                            background: Rectangle {
                                color: parent.highlighted ? "#6C63FF" : "#2a2a2a"
                                opacity: parent.highlighted ? 0.8 : 1.0
                            }
                        }
                    }
                }

                // Exercise section
                Text {
                    Layout.columnSpan: 2
                    text: "Exercises"
                    color: "#b0b0b0"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                ColumnLayout {
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    Layout.maximumHeight: 200
                    spacing: 10

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                        ColumnLayout {
                            id: exercisesColumn
                            width: parent.width
                            spacing: 8

                            Repeater {
                                model: exercisesModel

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 70
                                    color: "#1a1a1a"
                                    radius: 8
                                    border.width: 1
                                    border.color: "#404040"

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 12
                                        spacing: 12

                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            spacing: 4

                                            Text {
                                                text: model.nombre || "Exercise name"
                                                color: "#ffffff"
                                                font.pixelSize: 15
                                                font.weight: Font.Medium
                                            }

                                            Text {
                                                text: model.repeticiones + " reps · " + 
                                                      model.series + " sets · " + 
                                                      model.peso + " kg · " + 
                                                      model.grip
                                                color: "#7f8c8d"
                                                font.pixelSize: 12
                                            }
                                        }

                                        Components.GenericButton {
                                            Layout.preferredWidth: 40
                                            Layout.preferredHeight: 40
                                            buttonRadius: 8
                                            fontSize: 18
                                            text: "×"
                                            normalColor: "#3a3a3a"
                                            hoverColor: "#e74c3c"
                                            pressedColor: "#c0392b"
                                            onClicked: exercisesModel.remove(index)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Empty state
                    Text {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        visible: exercisesModel.count === 0
                        text: "No exercises added yet"
                        color: "#7f8c8d"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                    }

                    RowLayout {
                        spacing: 10

                        Components.GenericButton {
                            width: 160; height: 40; fontSize: 14; buttonRadius: 10
                            text: "+ Add new exercise"
                            textColor: "#ffffff"
                            normalColor: "#6C63FF"
                            hoverColor: "#7B73FF"
                            pressedColor: "#5A52E8"
                            onClicked: root.addExerciseRequested()
                        }

                        Components.GenericButton {
                            width: 160; height: 40; fontSize: 14; buttonRadius: 10
                            text: "Exercise list"
                            textColor: "#ffffff"
                            normalColor: "#6C63FF"
                            hoverColor: "#7B73FF"
                            pressedColor: "#5A52E8"
                            onClicked: root.addExerciseFromListRequested()
                        }
                    }
                }

                // Notes (ocupa 2 columnas)
                Text {
                    Layout.columnSpan: 2
                    text: "Notes"
                    color: "#b0b0b0"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                Rectangle {
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    color: "#1a1a1a"
                    radius: 8
                    border.width: notesArea.activeFocus ? 2 : 1
                    border.color: notesArea.activeFocus ? "#6C63FF" : "#404040"

                    Flickable {
                        anchors.fill: parent
                        anchors.margins: 10
                        contentHeight: notesArea.contentHeight
                        clip: true

                        TextArea.flickable: TextArea {
                            id: notesArea
                            placeholderText: "Additional notes about the seance..."
                            placeholderTextColor: "#666666"
                            color: "#ffffff"
                            background: Item {}
                            font.pixelSize: 14
                            selectByMouse: true
                            wrapMode: TextArea.Wrap
                        }

                        ScrollBar.vertical: ScrollBar {}
                    }
                }
            }

            // Actions button
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 10
                spacing: 15

                Item { Layout.fillWidth: true } // Spacer

                // Cancel button
                Components.GenericButton {
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 45

                    buttonRadius: 10; fontSize: 16;
                    normalColor: "#3a3a3a"
                    hoverColor: "#4a4a4a"
                    pressedColor: "#5a5a5a"
                    text: "Cancel"
                    onClicked: {
                        clearFields()
                        root.visible = false
                        root.cancelled()
                    }
                }

                // Button Add Seance
                Components.GenericButton {
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 45

                    buttonRadius: 10; fontSize: 16
                    text: root.editMode ? "Save Changes" : "Add Seance"
                    enabled: isFormValid()

                    onClicked: {
                        if (root.editMode) {
                            root.seanceUpdated(
                                root.editSeanceId,
                                seanceNameField.text,
                                getExercises(),
                                warmUpExercise.currentText,
                                notesArea.text
                            )
                        }
                        else {
                            root.seanceAdded(
                                seanceNameField.text,
                                getExercises(),
                                warmUpExercise.currentText,
                                notesArea.text
                            )
                        }
                        clearFields()
                        root.visible = false
                    }
                }
            }
        }
    }

    function getExercises() {
        var ids = []
        for (var i = 0; i < exercisesModel.count; i++) {
            var exerciseId = exercisesModel.get(i).id
            if (exerciseId !== undefined && exerciseId > 0)
                ids.push(exerciseId)
        }
        return ids
    }

    function isFormValid() {
        var hasName = seanceNameField.text.trim() !== ""
        var hasExercises = getExercises().length > 0
        var hasValidWarmUp = warmUpExercise.currentIndex > 0
        return hasName && hasExercises && hasValidWarmUp
    }

    function clearFields() {
        seanceNameField.text = ""
        exercisesModel.clear()
        warmUpExercise.currentIndex = 0
        notesArea.text = ""
    }

    function show() {
        clearFields()
        root.visible = true
    }

    function showEdit(seanceId, name, exercises, warmUp, notes) {
        editMode = true
        editSeanceId = seanceId
        clearFields()

        // Pre-fill fields
        seanceNameField.text = name
        notesArea.text = notes

        // Set warm-up combo box
        var warmUpOptions = ["-------", "Running", "Cycling", "Elliptical ", "Stretching", "Nothing"]
        var idx = warmUpOptions.indexOf(warmUp)
        warmUpExercise.currentIndex = idx >= 0 ? idx : 0

        // Populate exercises from QVariantList
        exercisesModel.clear()
        
        if (!exercises) {
            root.visible = true
            return
        }
        
        // QVariantList from C++ can be accessed with numeric indices
        try {
            // Check if it has a length property
            if (exercises.length !== undefined) {
                for (var i = 0; i < exercises.length; i++) {
                    if (exercises[i]) {
                        exercisesModel.append({
                            "id": exercises[i].id || 0,
                            "nombre": exercises[i].nombre || "",
                            "repeticiones": exercises[i].repeticiones || "",
                            "series": exercises[i].series || 0,
                            "peso": exercises[i].peso || 0,
                            "grip": exercises[i].grip || "",
                            "notas": exercises[i].notas || ""
                        })
                    }
                }
            }
            // Check if it's a ListModel (has count property)
            else if (exercises.count !== undefined) {
                for (var i = 0; i < exercises.count; i++) {
                    var exercise = exercises.get(i)
                    exercisesModel.append({
                        "id": exercise.id,
                        "nombre": exercise.nombre,
                        "repeticiones": exercise.repeticiones,
                        "series": exercise.series,
                        "peso": exercise.peso,
                        "grip": exercise.grip,
                        "notas": exercise.notas || ""
                    })
                }
            }
            // Iterate as object with numeric keys
            else {
                var i = 0
                while (exercises[i] !== undefined) {
                    exercisesModel.append({
                        "id": exercises[i].id || 0,
                        "nombre": exercises[i].nombre || "",
                        "repeticiones": exercises[i].repeticiones || "",
                        "series": exercises[i].series || 0,
                        "peso": exercises[i].peso || 0,
                        "grip": exercises[i].grip || "",
                        "notas": exercises[i].notas || ""
                    })
                    i++
                }
            }
        }
        catch (error) {
            console.error("Error processing exercises:", error)
        }
        root.visible = true
    }

    function addExercise(exercise) {
        // Check if exercise already exists
        for (var i = 0; i < exercisesModel.count; i++) {
            if (exercisesModel.get(i).id === exercise.id) {
                console.log("Exercise already added")
                return
            }
        }
        
        exercisesModel.append({
            "id": exercise.id,
            "nombre": exercise.nombre,
            "repeticiones": exercise.repeticiones,
            "series": exercise.series,
            "peso": exercise.peso,
            "grip": exercise.grip,
            "notas": exercise.notas || ""
        })
    }
}
