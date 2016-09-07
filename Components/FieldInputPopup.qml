import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Material.impl 2.0
import "qrc:/Components" as C

Popup {
	id: editPopup

	property string newString: ""

	onOpened: nameInput.forceActiveFocus()

	function done() {
		newString = nameInput.text
		editPopup.close()
		players.append({})

		if (fields.currentIndex !== fields.count) {
			fields.currentIndex = fields.count
		}

		nextItemInFocusChain(true).forceActiveFocus()
	}

	transformOrigin: Popup.TopRight
	dim: false

	background: Rectangle {
		radius: 3
		layer {
			enabled: true
			effect: ElevationEffect { elevation: 1 }
		}
	}

		contentItem: ColumnLayout {
			spacing: 20

			RowLayout {
				spacing: 10

				TextInput {
					id: nameInput

					MouseArea {
						onClicked: forceActiveFocus()
					}

					onAccepted: {
						done()
					}

					activeFocusOnTab: true
					maximumLength: 25
					color: "grey"
					anchors {
						left: parent.left
						leftMargin: 8
						verticalCenter: parent.verticalCenter
					}
				}
			}

			RowLayout {
				spacing: 10

				C.Button {
					id: okButton
					text: "Ok"
					onClicked: {
						done()
					}
				}

				C.Button {
					id: cancelButton
					text: "Cancel"
					onClicked: {
						editPopup.close()
						nameInput.clear()
					}
				}
			}
	}
}
