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
        
        // Exercise list
    }    
}
