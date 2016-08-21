import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Material.impl 2.0
import "qrc:/Components"

Page {
	//: The title of the page.
	title: qsTr("Course")

	background: Rectangle { color: Qt.darker(Material.background, 1.02) }
	padding: 0

	Pane {
		id: contentPane

		anchors {
			margins: 0
			fill: parent
		}


		GridLayout {
			id: courseInfo

			columns: 3
			rows: 2

			Image {
				id: courseImg

				Layout.column: 1
				Layout.row: 1
				Layout.rowSpan: 2

				Layout.minimumWidth: Window.width / 4;Layout.preferredWidth: Window.width / 3; Layout.maximumWidth: 300
				Layout.minimumHeight: Window.height / 3; Layout.maximumHeight: 400
				Layout.alignment: Qt.AlignTop | Qt.AlignLeft

				verticalAlignment: Image.AlignTop
				horizontalAlignment: Image.AlignLeft
				mipmap: true
				smooth: true
				fillMode: Image.PreserveAspectFit
//				sourceSize.width: window.width / 2
				source: "qrc:/images/courses/course1.png"
			}

			Rectangle {
				id: courseDescriptionCard

				Layout.column: 2
				Layout.row: 1

				Layout.alignment: Qt.AlignRight
				Layout.minimumWidth: 50; Layout.preferredWidth: Window.width * 0.6; Layout.maximumWidth: 300; Layout.rightMargin: 100
				Layout.minimumHeight: courseDescription.implicitHeight; Layout.maximumHeight: courseImg.height
				Layout.fillWidth: true

				radius: 3
				color: window.backgroundColor
				layer {
					enabled: true
					effect: ElevationEffect { elevation: 1 }
				}

				ColumnLayout {
					id: courseDescription

					Text {
						id: textTitle

						Layout.maximumWidth: courseDescriptionCard.width - padding

						padding: 10
						wrapMode: Text.Wrap
						elide: Text.ElideRight

						color: window.foregroundColor
						font.capitalization: Font.AllUppercase
						font.weight: Font.Bold
						//:Title text for the course description.
						text: qsTr("# - Coursename")
					}

					Text {
						id: textBody

						Layout.maximumWidth: courseDescriptionCard.width - 10
						Layout.margins: 5

						wrapMode: Text.Wrap

						color: window.foregroundColor
						//:Body text for the course description.
						text: qsTr("Description of the course with some additional fluff information. This area should be able to be expanded for continued reading.")
					}
				}
			}
		}

		//TODO: Add the player scores in a table-like layout of boxes or whatever
//		GridLayout {
//			id: playerScores



//			Repeater {
//				Rectangle {

//				}
//			}
//		}
	}
}
