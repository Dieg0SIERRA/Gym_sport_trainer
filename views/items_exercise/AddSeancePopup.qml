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

    signal seanceAdded(string name, var exercises, string warmUp, string notes, string warmUpTime, double warmUpDistance)
    signal addExerciseRequested()
    signal addExerciseFromListRequested()
    signal cancelled()

    // ── Edit mode properties ──
    property bool editMode: false
    property int editSeanceId: -1
    signal seanceUpdated(int seanceId, string name, var exercises, string warmUp, string notes, string warmUpTime, double warmUpDistance)


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
                    Layout.preferredHeight: 70
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

                RowLayout {
                    spacing: 15
                    visible: root.compactMode

                    ComboBox {
                        id: warmUpExercise
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40

                        model: ["-------", "Running", "Cycling", "Elliptical ", "Stretching", "Nothing"]

                        background: Rectangle {
                            color: warmUpExercise.pressed ? "#3a3a3a" : "#1a1a1a"
                            radius: 8
                            border.width: warmUpExercise.pressed ? 2 : 1
                            border.color: warmUpExercise.pressed ? "#6C63FF" : "#404040"
                        }

                        contentItem: Text {
                            leftPadding: 10
                            text: warmUpExercise.displayText
                            color: "#ffffff"
                            font.pixelSize: 14
                            verticalAlignment: Text.AlignVCenter
                        }

                        indicator: Text {
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            text: "▼"
                            color: "#6C63FF"
                            font.pixelSize: 12
                        }

                        popup: Popup {
                            y: warmUpExercise.height + 2
                            width: warmUpExercise.width
                            padding: 1

                            background: Rectangle {
                                color: "#2a2a2a"
                                border.color: "#6C63FF"
                                border.width: 1
                                radius: 8
                            }

                            contentItem: ListView {
                                clip: true
                                implicitHeight: contentHeight
                                model: warmUpExercise.popup.visible ? warmUpExercise.delegateModel : null
                                currentIndex: warmUpExercise.highlightedIndex
                                ScrollIndicator.vertical: ScrollIndicator {}
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

                    Text {
                        text: "Time: "
                        font.pixelSize: 12
                        color: "#b0b0b0"
                    }

                    TextField {
                        id: warmUpTime
                        Layout.preferredHeight: 30
                        Layout.preferredWidth: 50
                        placeholderText: "15:45"
                    }

                    Text {
                        text: "Distance: "
                        font.pixelSize: 12
                        color: "#b0b0b0"
                    }

                    TextField {
                        id: warmUpDistance
                        Layout.preferredHeight: 30
                        Layout.preferredWidth: 60
                        placeholderText: "3.84"

                        inputMethodHints: Qt.ImhFormattedNumbersOnly

                        validator: DoubleValidator {
                            bottom: 0.00
                            top: 99.99
                            decimals: 2
                            locale: Qt.locale()
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

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 40

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 50
                                        color: "#1a1a1a"
                                        radius: 8
                                        border.width: 1
                                        border.color: "#404040"

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.margins: 12
                                            spacing: 30

                                            Text {
                                                text: model.nombre || "Exercise name"
                                                color: "#ffffff"
                                                font.pixelSize: 16
                                                font.weight: Font.Medium
                                            }

                                            Item { Layout.fillWidth: true }

                                            Text {
                                                text: model.repeticiones + " reps · " +
                                                      model.series + " sets · " +
                                                      model.peso + " kg · " +
                                                      model.grip
                                                color: "#7f8c8d"
                                                font.pixelSize: 14
                                            }

                                            Components.GenericButton {
                                                Layout.preferredWidth: 30
                                                Layout.preferredHeight: 30
                                                buttonRadius: 6
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
                                notesArea.text,
                                warmUpTime.text,
                                getWarmUpDistance()
                            )
                        }
                        else {
                            root.seanceAdded(
                                seanceNameField.text,
                                getExercises(),
                                warmUpExercise.currentText,
                                notesArea.text,
                                warmUpTime.text,
                                getWarmUpDistance()
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
        var hasTime = warmUpTime.text.trim() !== ""
        var hasDistance = warmUpDistance.text.trim() !== ""
        return hasName && hasExercises && hasValidWarmUp && hasTime && hasDistance
    }

    function clearFields() {
        seanceNameField.text = ""
        exercisesModel.clear()
        warmUpExercise.currentIndex = 0
        notesArea.text = ""
        warmUpTime.text = ""
        warmUpDistance.text = ""
    }

    function show() {
        clearFields()
        root.visible = true
    }

    function showEdit(seanceId, name, exercises, warmUp, notes, warmUpTimeVal, warmUpDistanceVal) {
        editMode = true
        editSeanceId = seanceId
        clearFields()

        // Pre-fill fields
        seanceNameField.text = name
        notesArea.text = notes
        warmUpTime.text = warmUpTimeVal
        warmUpDistance.text = Number(warmUpDistanceVal).toLocaleString(Qt.locale(), 'f', 2)

        // Set warm-up combo box
        var warmUpOptions = ["-------", "Running", "Cycling", "Elliptical ", "Stretching", "Nothing"]
        var idx = warmUpOptions.indexOf(warmUp)
        warmUpExercise.currentIndex = idx >= 0 ? idx : 0

        // Populate exercises (exercises is now an array of objects)
        exercisesModel.clear()
        if (exercises && exercises.length > 0) {
            for (var i = 0; i < exercises.length; i++) {
                var ex = exercises[i]
                exercisesModel.append({
                    "id":           ex.id           || 0,
                    "nombre":       ex.nombre       || "",
                    "repeticiones": ex.repeticiones || "",
                    "series":       ex.series       || 0,
                    "peso":         ex.peso         || 0,
                    "grip":         ex.grip         || "",
                    "notas":        ex.notas        || ""
                })
            }
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

    function getWarmUpDistance() {
        if (warmUpDistance.acceptableInput && warmUpDistance.text.length > 0) {
            return Number.fromLocaleString(Qt.locale(), warmUpDistance.text)
        }
        return 0.0
    }
}
