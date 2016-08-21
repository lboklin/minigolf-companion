import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Material.impl 2.0

ApplicationWindow {
	id: window

	//TODO: Add a "Brand" theme which has the brand colors of an organization.
	//For now, "Light" is essentially the brand theme.
	property string theme: "Light"
	property color primaryColor: theme === "Light" ? "#C8D300" : "#31363b"
	property color backgroundColor: theme === "Light" ? "#eff0f1" : "#232629"
	property color foregroundColor: theme === "Light" ? "#31363b" : "#eff0f1"
	property color accentColor: theme === "Light" ? "#e03f90" : "#31363b"

	width: 360
	minimumWidth: 320
	height: 520
	minimumHeight: 320
	visible: true
	title:  Qt.application.name

	Material.theme: themeSettings.theme === "Light" ? Material.Light : Material.Dark
	Material.primary: themeSettings.primary
	Material.background: themeSettings.background
	Material.foreground: themeSettings.foreground
	Material.accent: themeSettings.accent

	//This intercepts the backbutton on android and makes it pop
	//the stackview instead of closing the app.
	onClosing: {
		if (Qt.platform.os == "android") {
			close.accepted = false;
			if (stackView.depth > 1) stackView.pop();
		}
	}

	Settings {
		id: settings

		property alias width: window.width
		property alias height: window.height
	}

	Settings {
		id: themeSettings

		property alias theme: window.theme
		property alias primary: window.primaryColor
		property alias background: window.backgroundColor
		property alias foreground: window.foregroundColor
		property alias accent: window.accentColor
	}

	header: ToolBar {
		id: toolBar

		height: 64
		padding: 0
		anchors.margins: 0

		RowLayout {
			spacing: 16
			anchors {
				fill: parent
			}

			ToolButton {
				id: drawerButton

				focusPolicy: Qt.NoFocus
				anchors {
					verticalCenter: parent.verticalCenter
					left: parent.left
				}

				onClicked: stackView.depth > 1 ? stackView.pop() : drawer.open()

				contentItem: Item {
					anchors {
						verticalCenter: parent.verticalCenter
						left: parent.left
						leftMargin: 16
					}

					Image {
						id: drawerIcon

						visible: false
						fillMode: Image.Pad
						mipmap: true
						sourceSize.height: 32
						source: {
							if ( stackView.depth > 1 ) {
								"images/icons/arrow_back.svg"
							} else {
								"images/icons/menu.svg"
							}
						}
					}

					Rectangle {
						id: drawerIconColor

						visible: false
						anchors.fill: drawerIcon
						color: "white"
					}

					OpacityMask {
						anchors.fill: drawerIcon
						maskSource: drawerIcon
						source: drawerIconColor
						cached: true
					}
				}
			}

			ToolButton {
				id: toolBarTitle

				activeFocusOnTab: false
				Layout.fillWidth: true
				//                Layout.fillHeight: true
				anchors {
					//                    top: parent.top; bottom: parent.bottom
					left: drawerButton.right; right: menuButton.left
					verticalCenter: parent.verticalCenter
				}

				onClicked: stackView.pop(null)

				contentItem: Text {
					id: toolBarText

					color: "white"
					text: window.title
					minimumPixelSize: 16; font.pixelSize: toolBar.height / 3
					verticalAlignment: Text.AlignVCenter
					anchors { left: parent.left; leftMargin: 80 - parent.x }
				}
			}

			ToolButton {
				id: menuButton

				focusPolicy: Qt.NoFocus
				anchors {
					verticalCenter: parent.verticalCenter
					right: parent.right
				}

				onClicked: optionsMenu.open()

				contentItem: Item {
					anchors {
						verticalCenter: parent.verticalCenter
						right: parent.right
						rightMargin: 16 - (menuIcon.width / 3)
					}

					Image {
						id: menuIcon

						visible: false
						anchors.centerIn: parent
						fillMode: Image.Pad
						mipmap: true
						sourceSize.height: 32
						source: "images/icons/more_vert.svg"
						smooth: true
					}

					Rectangle {
						id: menuIconColor

						visible: false
						anchors.fill: menuIcon
						color: "white"
					}

					OpacityMask {
						anchors.fill: menuIcon
						maskSource: menuIcon
						source: menuIconColor
						cached: true
					}
				}

				Menu {
					id: optionsMenu
					x: parent.width - width
					transformOrigin: Menu.TopRight

					MenuItem {
						property string toTheme: window.theme === "Light" ? "Dark" : "Light"
						text: "Switch to %1 Theme".arg(toTheme)
						onTriggered: window.theme = toTheme
					}
					MenuItem {
						text: "About"
						onTriggered: aboutDialog.open()
					}
				}
			}
		}
	}

	Drawer {
		id: drawer

		width: Math.min(window.width, window.height) / 3 * 2
		height: window.height

		Material.foreground: "grey"

		background: Rectangle {
			color: Material.background
			layer.enabled: {
				if (drawer.position != 0) {
					true
				} else {
					false
				}
			}
			layer.effect: ElevationEffect {
				elevation: 10
			}

			ListView {
				id: listView
				currentIndex: -1
				anchors.fill: parent

				delegate: ItemDelegate {
					width: parent.width
					text: model.title
					highlighted: ListView.isCurrentItem
					onClicked: {
						if (listView.currentIndex != index) {
							listView.currentIndex = index
							stackView.push(model.source)
						}
						drawer.close()
					}
				}

				model: ListModel {
					ListElement { title: "New Round"; source: "qrc:/pages/Players.qml" }
				}

				ScrollIndicator.vertical: ScrollIndicator { }
			}
		}
	}

	StackView {
		id: stackView

		property string requestedPage: ""

		//		onCurrentItemChanged: {
		//			toolBarLabel.text = stackView.currentItem.title
		//		}

		anchors.fill: parent

		initialItem: "qrc:/pages/Start.qml"
	}
}
