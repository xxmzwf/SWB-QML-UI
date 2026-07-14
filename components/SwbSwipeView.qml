import QtQuick
import QtQuick.Controls.Basic

SwipeView {
    id: control

    property SwbStyle theme: SwbStyle {}

    clip: true

    contentItem: ListView {
        id: view

        function alignCurrentPage() {
            if (view.count === 0)
                return

            view.forceLayout()
            view.positionViewAtIndex(control.currentIndex, ListView.Beginning)
        }

        model: control.contentModel
        interactive: control.interactive
        currentIndex: control.currentIndex
        focus: control.focus
        spacing: control.spacing
        orientation: control.orientation
        snapMode: ListView.SnapOneItem
        boundsBehavior: Flickable.StopAtBounds
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: 0
        preferredHighlightEnd: 0
        highlightMoveDuration: control.theme.animationDuration
        maximumFlickVelocity: 4 * (control.orientation === Qt.Horizontal ? width : height)

        onWidthChanged: {
            if (view.orientation === ListView.Horizontal)
                Qt.callLater(view.alignCurrentPage)
        }

        onHeightChanged: {
            if (view.orientation === ListView.Vertical)
                Qt.callLater(view.alignCurrentPage)
        }
    }
}
