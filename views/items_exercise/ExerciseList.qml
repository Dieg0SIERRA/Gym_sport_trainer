import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components" as Components

Rectangle {
    id: root
    color: "#ecf0f1"
    
    property int userId: -1
    property var exercises: []
       
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15
        
        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 15
            
            Text {
                text: "📋 My Exercises"
                font.pixelSize: 28
                font.weight: Font.Bold
                color: "#2c3e50"
            }
            
            Item { Layout.fillWidth: true }
            
            // exercise counter
            Rectangle {
                Layout.preferredWidth: 60
                Layout.preferredHeight: 35
                color: "#1E90FF"
                radius: 17.5
                
                Text {
                    anchors.centerIn: parent
                    text: root.exercises.length.toString()
                    color: "white"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                }
            }

            // Refresh Button
            Components.GenericButton {
                Layout.alignment: Qt.AlignLeft
                width: 45; height: 45; fontSize: 20; buttonRadius: 22.5
                text: "🔄"
                rotation: refreshArea.pressed ? 180 : 0
                color: refreshArea.pressed ? "#0066CC" :
                       refreshArea.containsMouse ? "#4169E1" : "#1E90FF"

                Behavior on rotation {
                    NumberAnimation { duration: 300 }
                }

                onClicked: {
                    // refresh exercise list
                }
            }
        }
        
        // Search/filter bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color: "white"
            radius: 25
            border.color: searchField.activeFocus ? "#1E90FF" : "#e0e0e0"
            border.width: 2

            RowLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10

                Text {
                    text: "🔍"
                    font.pixelSize: 18
                }

                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    placeholderText: "Search exercises..."
                    placeholderTextColor: "#95a5a6"
                    color: "#2c3e50"
                    background: Item {}
                    font.pixelSize: 15
                    selectByMouse: true

                    // onTextChanged: filterExercises()
                }
            }
        }
        
        // Exercise list
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"

            // Message when there are not exercise in the list
            Column {
                anchors.centerIn: parent
                spacing: 20
                visible: filteredModel.count === 0

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "📭"
                    font.pixelSize: 64
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: searchField.text !== "" ? "No exercises found" : "No exercises yet"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    color: "#7f8c8d"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: searchField.text !== "" ? "Try a different search" : "Click '+ Add exercise' to get started"
                    font.pixelSize: 14
                    color: "#95a5a6"
                }
            }

            // ScrollView con la lista
            ScrollView {
                anchors.fill: parent
                visible: filteredModel.count > 0
                clip: true

                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                ListView {
                    id: exerciseListView
                    anchors.fill: parent
                    spacing: 15
                    model: filteredModel

                    //TODO: Exercise information
                }
            }

        }
    }    
}
