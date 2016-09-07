import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtGraphicalEffects 1.0
import "qrc:/Components"

Page {
	id: page

	//: The title of the page.
	title: qsTr("Players")

	background: Rectangle {
		color: Qt.darker(Material.background, 1.02)
	}

	ListView {
		id: courseList

		displayMarginBeginning: 50
		displayMarginEnd: displayMarginBeginning
		spacing: 10
		anchors {
			margins: 20
			fill: parent
		}

		ListViewBackground { }

		delegate: Button {
			id: courseButton

			text: "Course %1: %2".arg(model.number).arg(model.course)
			height: Math.max(Math.min(implicitHeight * 2, window.height / 5), implicitHeight)
			anchors {
				left: parent.left
				right: parent.right
			}

			onClicked: { stackView.push("qrc:/pages/Course.qml") }
		}

		model: ListModel {
			//: The name of the course at which you can make your strokes.
			ListElement { course: qsTr("Coursename"); number: 1; image: "" }
			ListElement { course: qsTr("Coursename"); number: 2; image: "" }
			ListElement { course: qsTr("Coursename"); number: 3; image: "" }
			ListElement { course: qsTr("Coursename"); number: 4; image: "" }
			ListElement { course: qsTr("Coursename"); number: 5; image: "" }
			ListElement { course: qsTr("Coursename"); number: 6; image: "" }
			ListElement { course: qsTr("Coursename"); number: 7; image: "" }
		}

		ScrollIndicator.vertical: ScrollIndicator {
			anchors.right: Flickable.right
			//				anchors { right: parent.right; margins: -22 }
		}
	}
}
