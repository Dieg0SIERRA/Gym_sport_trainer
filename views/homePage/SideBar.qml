import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    color: "#2c3e50"

    property string currentSection: "home"

    // Signal to notify changes
    signal sectionChanged(string section)

    // separated data model
    property var menuItems: [
        { name: "Home", icon: "🏠", section: "home" },
        { name: "Seance", icon: "🏋️", section: "seance" },
        { name: "Exercise", icon: "🏃", section: "exercise" },
        { name: "Program", icon: "📋", section: "program" },
        { name: "Stats", icon: "📊", section: "stats" }
    ]

    Column {
        anchors.fill: parent
        spacing: 0

        // upper spacer
        Item {
            width: parent.width
            height: 40
        }

        // Menu Items
        Repeater {
            model: root.menuItems

            delegate: SideBarItem {
                width: root.width
                height: 60
                itemName: modelData.name
                itemIcon: modelData.icon
                itemSection: modelData.section
                isActive: root.currentSection === modelData.section

                onClicked: {
                    root.sectionChanged(modelData.section)
                }
            }
        }

        // space to to push-up elements
        Item {
            width: parent.width
            Layout.fillHeight: true
        }
    }
}
