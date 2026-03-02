import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components" as Components

Rectangle {
    id: root
    
    // Seance properties
    property int seanceId: 0
    property string seanceName: ""
    property var exerciseList: []  // Changed to var to accept array
    property string warmUp: ""
    property string notes: ""
    property string createdAt: ""
    
    // Signals
    signal editClicked(int id)
    signal deleteClicked(int id)
    
    width: parent.width
    height: expanded ? Math.max(contentColumn.implicitHeight + 40, 400) : 120
    color: "#ffffff"
    radius: 15
    border.color: "#e0e0e0"
    border.width: 1
    
    property bool expanded: false
    
    Behavior on height {
        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.expanded = !root.expanded
        cursorShape: Qt.PointingHandCursor
    }
    
    ColumnLayout {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: 20
        spacing: 12
        
        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 15
            
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
                    text: root.seanceName
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: "#2c3e50"
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
                
                RowLayout {
                    spacing: 15
                    
                    Text {
                        text: "📊 " + (root.exerciseList && root.exerciseList.count !== undefined ? root.exerciseList.count : 0) + " exercises"
                        font.pixelSize: 14
                        color: "#7f8c8d"
                    }
                    
                    Text {
                        text: "⚖️ " + root.warmUp
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
        
        // Details
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            visible: root.expanded
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
                    text: "warm -up:"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    color: "#2c3e50"
                }
                
                Text {
                    text: root.warmUp
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

            // Exercises section
            ColumnLayout {
                Layout.fillWidth: true
                Layout.topMargin: 15
                spacing: 8
                
                Text {
                    text: "Exercises:"
                    font.pixelSize: 14
                    font.weight: Font.Bold
                    color: "#2c3e50"
                    visible: root.exerciseList && root.exerciseList.count > 0
                }

                Repeater {
                    model: root.exerciseList
                    visible: root.exerciseList && root.exerciseList.count > 0

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: exerciseContent.implicitHeight + 20
                        color: "#f8f9fa"
                        radius: 8
                        border.color: "#e0e0e0"
                        border.width: 1

                        ColumnLayout {
                            id: exerciseContent
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 6                            

                            // Exercise details in a grid
                            GridLayout {
                                Layout.fillWidth: true
                                columns: 9
                                columnSpacing: 15
                                rowSpacing: 4

                                // Exercise name
                                Text {
                                    text: model.nombre || "Unknown exercise"
                                    font.pixelSize: 14
                                    font.weight: Font.Bold
                                    color: "#2c3e50"
                                    Layout.fillWidth: true
                                }

                                // Repeticiones
                                Text {
                                    text: "Reps:"
                                    font.pixelSize: 12
                                    color: "#7f8c8d"
                                    font.weight: Font.Medium
                                }
                                Text {
                                    text: model.repeticiones || "-"
                                    font.pixelSize: 12
                                    color: "#34495e"
                                }

                                // Series
                                Text {
                                    text: "Sets:"
                                    font.pixelSize: 12
                                    color: "#7f8c8d"
                                    font.weight: Font.Medium
                                }
                                Text {
                                    text: model.series || "-"
                                    font.pixelSize: 12
                                    color: "#34495e"
                                }

                                // Peso
                                Text {
                                    text: "Weight:"
                                    font.pixelSize: 12
                                    color: "#7f8c8d"
                                    font.weight: Font.Medium
                                }
                                Text {
                                    text: model.peso ? model.peso + " kg" : "-"
                                    font.pixelSize: 12
                                    color: "#34495e"
                                }

                                // Grip
                                Text {
                                    text: "Grip:"
                                    font.pixelSize: 12
                                    color: "#7f8c8d"
                                    font.weight: Font.Medium
                                }
                                Text {
                                    text: model.grip || "-"
                                    font.pixelSize: 12
                                    color: "#34495e"
                                }
                            }
                        }
                    }
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
            
            // Buttons
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 5
                spacing: 10
                
                Item { Layout.fillWidth: true }

                // Edit button
                Components.GenericButton {
                    Layout.alignment: Qt.AlignLeft
                    width: 80; height: 35; fontSize: 13; buttonRadius: 8
                    text: "✏️ Edit"
                    textColor: "white"
                    normalColor: "#1E90FF"
                    hoverColor: "#4169E1"
                    pressedColor: "#0066CC"

                    onClicked: {
                        root.editClicked(root.seanceId)
                        mouse.accepted = true
                    }
                }
                
                // Delete button
                Components.GenericButton {
                    Layout.alignment: Qt.AlignLeft
                    width: 90; height: 35; fontSize: 13; buttonRadius: 8
                    text: "🗑️ Delete"
                    textColor: "white"
                    normalColor: "#d04040"
                    hoverColor: "#e74c3c"
                    pressedColor: "#c0392b"

                    onClicked: {
                        root.deleteClicked(root.seanceId)
                    }
                }
            }
        }
    }
    
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
