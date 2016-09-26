import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "qrc:/Components"

Page {
	id: mainMenu

	readonly property int menuWidth: Math.max(buttonMenu.implicitWidth, Math.min(buttonMenu.implicitWidth * 1.5, mainMenu.availableWidth / 3))
	readonly property int menuHeight: Math.max(buttonMenu.implicitHeight, Math.min(buttonMenu.implicitHeight * 1.5, mainMenu.availableHeight / 3))

	ColumnLayout {
		id: buttonMenu

		anchors {
//			top: parent.verticalCenter / 2
//			horizontalCenter: parent.horizontalCenter
			left: parent.left
			right: parent.right
			bottom: parent.bottom
		}
		height: 128

		Repeater {
            delegate: FlatButton {
				id: button

				onClicked: stackView.push("qrc:/pages/%1.qml".arg(model.page))

				flat: true
				text: model.label
				height: Math.max(Math.min(implicitHeight * 2, window.height / 5), implicitHeight)
				anchors {
                    horizontalCenter: parent.horizontalCenter
				}
			}

			model: ListModel {
				//:This string explains what happens when the button is pressed. this is located in the main menu.
				ListElement { label: qsTr("Continue Round"); request: "Continue Round"; page: "Overview" }
				ListElement { label: qsTr("New Round"); request: "New Round"; page: "Players" }
//				ListElement { label: qsTr("History"); request: "History"; page: "Round" }
			}
		}
	}
}
