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

        // --- SideBar ---
        SideBar {
            id: sidebar
            width: 280
            height: parent.height
            currentSection: root.currentSection

            onSectionChanged: {
                root.currentSection = section
            }
        }

        // --- Dashboard area ---
        Dashboard {
            id: dashboard
            width: parent.width - sidebar.width
            height: parent.height
            currentSection: root.currentSection
        }
    }
}
