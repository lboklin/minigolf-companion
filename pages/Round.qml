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

	Component.onCompleted: {
		stackView.pop()
		stackView.push( "qrc:/pages/%1.qml".arg(stackView.requestedPage) )
	}
}
