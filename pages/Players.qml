import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Material.impl 2.0
import QtGraphicalEffects 1.0
import "qrc:/Components"

Page {
	id: page

	//: The title of the page.
	title: qsTr("Players")


	background: Rectangle { color: Qt.darker(Material.background, 1.02) }

	function playerColor(playerIndex) {
		var playerColors = [Material.color(Material.Red),
							Material.color(Material.Blue),
							Material.color(Material.Green),
							Material.color(Material.Yellow),
							Material.color(Material.Purple),
							Material.color(Material.Amber)]

		return playerColors[playerIndex]
	}

	ListView {
		id: playerList

		//This prevents the children items popping in and out as they disappear.
		displayMarginBeginning: 50; displayMarginEnd: displayMarginBeginning

		spacing: 10
		anchors { margins: 20; fill: parent }

		delegate: ItemDelegate {
			id: playerCard

			padding: 8
			height: Math.max(Math.min(Screen.height / 14, Window.height / 5), 50)
			anchors { left: parent.left; right: parent.right }

			//When card gains focus, just give focus to the name input field.
			onActiveFocusChanged: nameField.forceActiveFocus()

			background: Rectangle {
				radius: 3
				color: Material.background

				layer {
					enabled: true
					effect: ElevationEffect { elevation: 1 }
				}
			}

			contentItem: RowLayout {

				spacing: 20
				anchors { fill: parent; margins: 0 }

				TextField {
					id: nameField

					Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
					Layout.leftMargin: 16

					color: Material.foreground
					//: This is the placeholderText for player name input field.
					placeholderText: qsTr("Player Name")
					validator: RegExpValidator { regExp: (/[A-Öa-ö ]+/) }

					onAccepted: {
						if (playerList.nextItemInFocusChain(true).acceptableInput)
							players.append({}); playerList.currentIndex = index + 1
					}
				}

				ComboBox {
					id: colorChooser

					property color currentColor: Material.color(Material.Red)

					Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
					Layout.rightMargin: 16
					Layout.preferredHeight: nameField.height
					Layout.preferredWidth: nameField.height

					activeFocusOnTab: false
					displayText: ""
					padding: 2

					model:  [ Material.Red, Material.Blue, Material.Green, Material.Amber, Material.Purple ]

					popup: Popup {
						height: contentHeight
						width: colorChooser.width

						contentItem: ColumnLayout {
							anchors.fill: parent

							Repeater {
								height: colorChooser.height
								anchors { left: parent.left; right: parent.right }

								delegate: Rectangle { radius: 3; color: Material.color(modelData) }

								model: colorChooser.model
							}
						}

						//						background: Rectangle { color: "transparent" }
					}

					contentItem: Rectangle {
						radius: 3
						color: playerColor(index)
						layer {
							enabled: true
							effect: ElevationEffect { elevation: 1 }
						}
					}

					background: Rectangle { color: "transparent" }

					onActivated: {
						currentColor = model[index]
					}
				}
			}
		}

		model: ListModel {
			id: players

			ListElement { player: 1; name: ""; color: "red" }
		}

		footer: ColumnLayout {
			id: buttons

			anchors {
				left: parent.left
				right: parent.right
			}

			Button {
				id: doneButton

				enabled: false
				flat: true
				//: This is the label on the button to finish adding players and go to next page.
				text: qsTr("Done")
				anchors {
					horizontalCenter: parent.horizontalCenter
				}

				onPressed: { stackView.push("qrc:/pages/Overview.qml") }

				Connections {
					target: playerList.model

					onCountChanged: {
						doneButton.enabled = true
					}
				}
			}
		}

		ListViewBackground { }

		ScrollIndicator.vertical: ScrollIndicator {
			anchors {
				right: parent.right
				margins: -12
			}
		}
	}

	/*
	Loader {
		id: buttonLoader

		Connections {
			target: playerList

			onPlayerAdded: {
				buttonLoader.source = "qrc:/Components/Menu.qml"
			}
		}
	}
	*/
}
