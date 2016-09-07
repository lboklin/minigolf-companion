import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Material.impl 2.0

Pane {
    id: menuPane

    RowLayout {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Repeater {
            delegate: Button {
                id: button

                text: model.label
                anchors {
                    margins: 0
                    left: parent.left
                    right: parent.right
                }
            }

            model: listModel
        }
    }
    property Component model: ListModel {
        id: listModel
    }

}
