import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root

    property string currentSection: "home"
    property int currentUserId: 0
    property string currentUsername: ""

    Row {
        anchors.fill: parent
        spacing: 0

        SideBar {
            id: sidebar
            width: 280
            height: parent.height
            currentSection: root.currentSection

            onSectionChanged: function(section) {
                root.currentSection = section
            }
        }

        Dashboard {
            id: dashboard
            width: parent.width - sidebar.width
            height: parent.height
            currentSection: root.currentSection
        }
    }
}
