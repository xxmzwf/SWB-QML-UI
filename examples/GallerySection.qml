import QtQuick
import QtQuick.Layouts
import SwbControls

Rectangle {
    id: section

    property string title: ""
    property string filterText: ""
    property int bodyHeight: 0
    default property alias content: body.data

    visible: filterText === ""
             || title.toLowerCase().indexOf(filterText.toLowerCase()) !== -1
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.preferredWidth: 1
    Layout.preferredHeight: bodyHeight > 0 ? bodyHeight : Math.max(96, body.implicitHeight + 24)
    color: SwbTheme.popover
    radius: SwbTheme.radius
    border.color: SwbTheme.border
    border.width: 1

    ColumnLayout {
        id: body

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 12
        spacing: 8

        Text {
            text: section.title
            color: SwbTheme.foreground
            font.pixelSize: 16
            font.weight: Font.DemiBold
            Layout.fillWidth: true
        }
    }
}
