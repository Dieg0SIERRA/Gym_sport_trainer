import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    anchors.fill: parent
    color: "#f5f5f5"

    // Property to active item in the sidebar
    property string currentSection: "home"

    Row {
        anchors.fill: parent
        spacing: 0

        // --- SIDEBAR ---
        Rectangle {
            id: sidebar
            width: 280
            height: parent.height
            color: "#2c3e50"

            // Menu Items
        }

        // --- Main area (placeholder) ---
        Rectangle {
            width: parent.width - sidebar.width
            height: parent.height
            color: "#ecf0f1"

            // Content of placeholder
            
        }
    }
}
