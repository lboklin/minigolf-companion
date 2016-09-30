import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Page {
    id: page

    property bool roundStarted: false
    property string currentCourse: ""

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Players { }
        Overview { }
        Course { }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("Players")
        }
        TabButton {
            text: qsTr("Courses")
            enabled: roundStarted
        }
        TabButton {
            text: qsTr("%1").arg(currentCourse)
            enabled: roundStarted && (currentCourse !== "")
        }
    }
}
