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

    property int userId: -1
    property var exercises: []

    signal exerciseSelected(string name)
    signal cancelled()

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.visible = false
            root.cancelled()
        }
    }

    Rectangle {
        width: 500
        height: 500
        anchors.centerIn: parent
        color: "#2a2a2a"
        radius: 20
        border.width: 2
        border.color: "#6C63FF"

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 25
            spacing: 15

            // Title
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "📋 Select Exercise"
                color: "#ffffff"
                font.pixelSize: 22
                font.weight: Font.Bold
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 2
                color: "#6C63FF"
                opacity: 0.3
            }

            // Search bar
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 45
                color: "#1a1a1a"
                radius: 8
                border.width: searchField.activeFocus ? 2 : 1
                border.color: searchField.activeFocus ? "#6C63FF" : "#404040"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8

                    Text {
                        text: "🔍"
                        font.pixelSize: 16
                    }

                    TextField {
                        id: searchField
                        Layout.fillWidth: true
                        placeholderText: "Search exercises..."
                        placeholderTextColor: "#666666"
                        color: "#ffffff"
                        background: Item {}
                        font.pixelSize: 14
                        selectByMouse: true
                        onTextChanged: filterExercises()
                    }
                }
            }

            // Empty state
            Text {
                Layout.alignment: Qt.AlignHCenter
                visible: filteredModel.count === 0
                text: searchField.text !== "" ? "No exercises found" : "No exercises available"
                color: "#7f8c8d"
                font.pixelSize: 16
            }

            // Exercise list
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                ListView {
                    id: exerciseListView
                    anchors.fill: parent
                    spacing: 8
                    model: filteredModel

                    delegate: Rectangle {
                        width: exerciseListView.width
                        height: 55
                        radius: 10
                        color: delegateArea.pressed ? "#5A52E8" :
                            delegateArea.containsMouse ? "#3a3a3a" : "#1a1a1a"
                        border.width: 1
                        border.color: delegateArea.containsMouse ? "#6C63FF" : "#404040"

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 12

                            Text {
                                text: "💪"
                                font.pixelSize: 20
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: model.name
                                    color: "#ffffff"
                                    font.pixelSize: 15
                                    font.weight: Font.Medium
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: model.repetitions + " · " + model.weight + " kg · " + model.grip
                                    color: "#7f8c8d"
                                    font.pixelSize: 12
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }

                            Text {
                                text: "›"
                                color: "#6C63FF"
                                font.pixelSize: 20
                                font.weight: Font.Bold
                            }
                        }

                        MouseArea {
                            id: delegateArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.exerciseSelected(model.name)
                                root.visible = false
                            }
                        }
                    }
                }
            }

            // Cancel button
            Components.GenericButton {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 120
                Layout.preferredHeight: 40
                buttonRadius: 10; fontSize: 14
                text: "Cancel"
                normalColor: "#3a3a3a"
                hoverColor: "#4a4a4a"
                pressedColor: "#5a5a5a"
                onClicked: {
                    root.visible = false
                    root.cancelled()
                }
            }
        }
    }

    ListModel {
        id: filteredModel
    }

    function show() {
        searchField.text = ""
        loadExercises()
        root.visible = true
    }

    function loadExercises() {
        if (root.userId <= 0) return
        root.exercises = DatabaseManager.getExercisesByUser(root.userId)
        filterExercises()
    }

    function filterExercises() {
        filteredModel.clear()
        var searchText = searchField.text.toLowerCase()

        for (var i = 0; i < root.exercises.length; i++) {
            var ex = root.exercises[i]
            if (searchText !== "") {
                if (!ex.name.toLowerCase().includes(searchText) &&
                    !ex.grip.toLowerCase().includes(searchText)) {
                    continue
                }
            }
            filteredModel.append(ex)
        }
    }
}