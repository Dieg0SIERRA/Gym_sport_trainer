import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components" as Components

Rectangle {
    id: root

    // Exercise properties
    property int exerciseId: 0
    property string exerciseName: ""
    property string repetitions: ""
    property int series: 0
    property real weight: 0.0
    property string grip: ""
    property string notes: ""
    property string createdAt: ""

    // Mode properties
    property bool compactMode: false  // New: compact mode for variations in template list

    // Signals
    signal editClicked(int id)
    signal deleteClicked(int id)

    width: parent.width
    height: compactMode ? 70 : (expanded ? 220 : 120)
    color: compactMode ? "#f8f9fa" : "#ffffff"
    radius: compactMode ? 8 : 15
    border.color: "#e0e0e0"
    border.width: 1

    property bool expanded: false
    
    Behavior on height {
        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
    }

    MouseArea {
        anchors.fill: parent
        enabled: !root.compactMode  // Disable expansion in compact mode
        onClicked: root.expanded = !root.expanded
        cursorShape: root.compactMode ? Qt.ArrowCursor : Qt.PointingHandCursor
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: root.compactMode ? 10 : 20
        spacing: root.compactMode ? 6 : 12

        // Header - Compact mode
        RowLayout {
            Layout.fillWidth: true
            spacing: 15
            visible: root.compactMode

            Text {
                text: "💪"
                font.pixelSize: 20
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 4
                columnSpacing: 15
                rowSpacing: 4

                Text {
                    text: "Reps: " + (root.repetitions || "-")
                    font.pixelSize: 12
                    color: "#34495e"
                }

                Text {
                    text: "Sets: " + (root.series || "-")
                    font.pixelSize: 12
                    color: "#34495e"
                }

                Text {
                    text: "Weight: " + (root.weight || "0") + " kg"
                    font.pixelSize: 12
                    color: "#34495e"
                }

                Text {
                    text: "Grip: " + (root.grip || "-")
                    font.pixelSize: 12
                    color: "#34495e"
                }
            }

            Item {
                Layout.fillWidth: true  // Spacer to push button to the right
            }

            Rectangle {
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                color: compactDeleteArea.pressed ? "#c0392b" :
                       compactDeleteArea.containsMouse ? "#e74c3c" : "#d04040"
                radius: 6

                Text {
                    anchors.centerIn: parent
                    text: "🗑️"
                    font.pixelSize: 14
                }

                MouseArea {
                    id: compactDeleteArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.deleteClicked(root.exerciseId)
                        mouse.accepted = true
                    }
                }
            }
        }

        // Header - Normal mode
        RowLayout {
            Layout.fillWidth: true
            spacing: 15
            visible: !root.compactMode

            // Icon
            Rectangle {
                Layout.preferredWidth: 50
                Layout.preferredHeight: 50
                color: "#1E90FF"
                radius: 25

                Text {
                    anchors.centerIn: parent
                    text: "💪"
                    font.pixelSize: 24
                }
            }

            // Main information
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: root.exerciseName
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: "#2c3e50"
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                RowLayout {
                    spacing: 15

                    Text {
                        text: "📊 " + root.repetitions
                        font.pixelSize: 14
                        color: "#7f8c8d"
                    }

                    Text {
                        text: "⚖️ " + root.weight + " kg"
                        font.pixelSize: 14
                        color: "#7f8c8d"
                    }

                    Text {
                        text: "🤝 " + root.grip
                        font.pixelSize: 14
                        color: "#7f8c8d"
                    }
                }
            }

            // Expand indicator
            Text {
                text: root.expanded ? "▲" : "▼"
                font.pixelSize: 16
                color: "#1E90FF"
            }
        }
        
        // Details (only in normal mode when expanded)
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            visible: !root.compactMode && root.expanded
            opacity: root.expanded ? 1.0 : 0.0
            
            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
            
            // separator line
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: "#e0e0e0"
            }
            
            // Information
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                rowSpacing: 8
                columnSpacing: 15
                
                Text {
                    text: "Series:"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    color: "#2c3e50"
                }
                
                Text {
                    text: root.series.toString()
                    font.pixelSize: 14
                    color: "#7f8c8d"
                }
                
                Text {
                    text: "Created:"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    color: "#2c3e50"
                }
                
                Text {
                    text: formatDate(root.createdAt)
                    font.pixelSize: 14
                    color: "#7f8c8d"
                }
            }
            
            // Notes
            Text {
                Layout.fillWidth: true
                text: "Notes:"
                font.pixelSize: 14
                font.weight: Font.Medium
                color: "#2c3e50"
                visible: root.notes !== ""
            }
            
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                color: "#f8f9fa"
                radius: 8
                visible: root.notes !== ""
                
                Text {
                    anchors.fill: parent
                    anchors.margins: 10
                    text: root.notes
                    font.pixelSize: 13
                    color: "#7f8c8d"
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                }
            }

            // Buttons (they are desables for the moment)
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 5
                spacing: 10
                visible: false
                enabled: false

                Item { Layout.fillWidth: true }

                // Edit button
                Components.GenericButton {
                    Layout.alignment: Qt.AlignLeft
                    width: 80; height: 35; fontSize: 13; buttonRadius: 8
                    text: "✏️ Edit"
                    textColor: "white"
                    color: editArea.pressed ? "#0066CC" :
                           editArea.containsMouse ? "#4169E1" : "#1E90FF"

                    onClicked: {
                        root.editClicked(root.exerciseId)
                        mouse.accepted = true
                    }
                }

                // Delete button
                Components.GenericButton {
                    Layout.alignment: Qt.AlignLeft
                    width: 90; height: 35; fontSize: 13; buttonRadius: 8
                    text: "🗑️ Delete"
                    textColor: "white"
                    color: deleteArea.pressed ? "#c0392b" :
                           deleteArea.containsMouse ? "#e74c3c" : "#d04040"

                    onClicked: {
                        root.deleteClicked(root.exerciseId)
                        mouse.accepted = true
                    }
                }
            }
        }
    }
    
    // Función para formatear fecha
    function formatDate(dateString) {
        if (!dateString) return ""
        
        var date = new Date(dateString)
        var day = date.getDate()
        var month = date.getMonth() + 1
        var year = date.getFullYear()
        var hours = date.getHours()
        var minutes = date.getMinutes()
        
        return day + "/" + month + "/" + year + " " + 
               (hours < 10 ? "0" : "") + hours + ":" + 
               (minutes < 10 ? "0" : "") + minutes
    }
}
