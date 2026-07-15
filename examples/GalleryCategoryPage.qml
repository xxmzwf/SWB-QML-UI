import QtQuick
import QtQuick.Layouts
import SwbControls

SwbScrollView {
    id: page

    property string filterText: ""
    property bool active: true
    readonly property int columns: grid.columns
    default property alias sections: grid.data

    contentWidth: availableWidth

    Item {
        width: page.availableWidth
        implicitHeight: grid.implicitHeight + 32

        GridLayout {
            id: grid

            x: 24
            y: 16
            width: Math.max(0, parent.width - 48)
            columnSpacing: 16
            rowSpacing: 16
            columns: width >= 720 ? 2 : 1
        }
    }
}
