import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Material.impl 2.0
import "qrc:/Components" as C

Page {
	id: page

	/*
	SwipeView {
		id: swipeView

		Component.onCompleted: {
			if (stackView.requestedPage === "Continue Round") {
				swipeView.currentIndex = 1
			}
		}

		anchors.fill: parent

		Repeater {
			delegate: Loader {
				id: pageLoader

				source: "qrc:/pages/%1.qml".arg(model.page)
			}

			model: ListModel {
				id: pageList

				ListElement { page: "Players" }
				ListElement { page: "Overview" }
			}
		}
	}
	*/

	Component.onCompleted: {
		stackView.pop()
		stackView.push( "qrc:/pages/%1.qml".arg(stackView.requestedPage) )
	}

	/*
	ToolBar {
		id: bottomBar

		Material.primary: Material.accent
		Material.elevation: 8
		anchors {
			top: pageIndicator.top
			left: parent.left
			right: parent.right
			bottom: pageIndicator.bottom
		}
	}

	PageIndicator {
		id: pageIndicator
		count: swipeView.count
		currentIndex: swipeView.currentIndex
		z: 1
		anchors {
			horizontalCenter: parent.horizontalCenter
			bottom: parent.bottom
		}
	}
	*/

}
