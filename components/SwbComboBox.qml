pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Templates as T

ComboBox {
    id: control

    property SwbStyle theme: SwbStyle {}

    property string placeholderText: ""

    // Filter only after the user types; initially show every item when opening.
    property bool searching: false
    readonly property string query: searching ? editText.toLowerCase() : ""
    // Number of matches for the current query, used by the empty-state message.
    readonly property int matchCount: {
        if (query.length === 0)
            return count
        var n = 0
        for (var i = 0; i < count; i++)
            if (String(textAt(i)).toLowerCase().indexOf(query) >= 0)
                n++
        return n
    }

    editable: true
    implicitWidth: 220
    leftPadding: 10
    rightPadding: 34
    topPadding: 0
    bottomPadding: 0
    font.pixelSize: control.theme.fontSize
    opacity: enabled ? 1.0 : 0.5

    // Enter selects the first matching item.
    onAccepted: {
        for (var i = 0; i < count; i++) {
            if (query.length === 0 || String(textAt(i)).toLowerCase().indexOf(query) >= 0) {
                currentIndex = i
                popup.close()
                break
            }
        }
    }

    // Editable trigger background matching TextField, with a focus highlight.
    background: Rectangle {
        implicitWidth: 220
        implicitHeight: control.theme.controlHeight
        radius: control.theme.radius
        color: "transparent"
        border.color: control.activeFocus ? control.theme.ring : control.theme.border
        border.width: 1
        Behavior on border.color { ColorAnimation { duration: control.theme.animationDuration } }

        // Focus ring shown while editing.
        Rectangle {
            anchors.fill: parent
            anchors.margins: -control.theme.focusRingWidth
            radius: parent.radius + control.theme.focusRingWidth
            color: "transparent"
            border.color: control.theme.focusRing
            border.width: control.theme.focusRingWidth
            visible: control.activeFocus
        }
    }

    // Editable trigger content that filters as the user types.
    contentItem: TextField {
        padding: 0
        text: control.editable ? control.editText : control.displayText
        placeholderText: control.placeholderText
        placeholderTextColor: control.theme.mutedForeground
        font: control.font
        color: control.theme.foreground
        selectionColor: control.theme.primary
        selectedTextColor: control.theme.primaryForeground
        verticalAlignment: TextInput.AlignVCenter
        enabled: control.editable
        background: null

        onTextEdited: {
            control.searching = true
            if (!control.popup.visible)
                control.popup.open()
        }

        // Themed right-click editing menu.
        T.ContextMenu.menu: SwbTextEditingContextMenu {
            editor: parent
            theme: control.theme
        }
        // Open after the click finishes so cursor placement is preserved and the popup overlay
        // cannot mistake the end of the same click for an outside press.
        TapHandler {
            acceptedButtons: Qt.LeftButton
            onTapped: if (!control.popup.visible) Qt.callLater(control.popup.open)
        }
    }

    // Right-side arrow trigger highlighted with accent on hover or while open.
    indicator: Item {
        x: control.width - width - 8
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 24
        height: 24

        // Passive hover detection preserves the existing click behavior.
        HoverHandler { id: arrowHover }

        // Fill with accent only while hovered and closed. Start from zero-alpha accent rather
        // than transparent black to prevent a black flash during the transition.
        Rectangle {
            anchors.fill: parent
            radius: control.theme.radiusSm
            color: arrowHover.hovered && !control.popup.visible ? control.theme.accent : control.theme.withAlpha(control.theme.accent, 0)
            Behavior on color { ColorAnimation { duration: control.theme.animationDuration } }
        }

        // Dropdown arrow icon.
        Canvas {
            anchors.centerIn: parent
            width: control.theme.iconSize
            height: control.theme.iconSize
            property color strokeColor: control.theme.mutedForeground
            onStrokeColorChanged: requestPaint()
            onPaint: {
                let ctx = getContext("2d")
                let s = width / 24
                ctx.reset()
                ctx.strokeStyle = strokeColor
                ctx.lineWidth = 2
                ctx.lineCap = "round"
                ctx.lineJoin = "round"
                ctx.beginPath()
                ctx.moveTo(6 * s, 9 * s)
                ctx.lineTo(12 * s, 15 * s)
                ctx.lineTo(18 * s, 9 * s)
                ctx.stroke()
            }
        }
    }

    // Collapse list items that do not match the current query.
    delegate: ItemDelegate {
        id: item
        width: ListView.view.width
        height: matched ? 32 : 0
        visible: matched
        clip: true
        padding: 8
        hoverEnabled: control.hoverEnabled

        required property int index
        required property var modelData

        readonly property bool matched: control.query.length === 0
                                        || String(modelData).toLowerCase().indexOf(control.query) >= 0

        highlighted: control.highlightedIndex === index

        background: Rectangle {
            radius: control.theme.radiusSm
            color: item.highlighted ? control.theme.accent : "transparent"
        }
        contentItem: Item {
            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 20
                text: item.modelData
                font.pixelSize: control.theme.fontSize
                color: item.highlighted ? control.theme.accentForeground : control.theme.foreground
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            // Check icon marking the selected item.
            Canvas {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: control.theme.iconSize
                height: control.theme.iconSize
                visible: control.currentIndex === item.index
                property color strokeColor: control.theme.foreground
                onStrokeColorChanged: requestPaint()
                onVisibleChanged: if (visible) requestPaint()
                onPaint: {
                    let ctx = getContext("2d")
                    let s = width / 24
                    ctx.reset()
                    ctx.strokeStyle = strokeColor
                    ctx.lineWidth = 2
                    ctx.lineCap = "round"
                    ctx.lineJoin = "round"
                    ctx.beginPath()
                    ctx.moveTo(20 * s, 6 * s)
                    ctx.lineTo(9 * s, 17 * s)
                    ctx.lineTo(4 * s, 12 * s)
                    ctx.stroke()
                }
            }
        }
    }

    // Popup panel with fade, zoom, and slide-in animation.
    popup: Popup {
        id: popup

        y: control.height + 6
        width: control.width
        implicitHeight: control.matchCount === 0 ? 40 : Math.min(contentItem.implicitHeight + 8, 300)
        padding: 4

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: control.theme.animationDuration; easing.type: Easing.OutCubic }
            NumberAnimation { property: "scale"; from: 0.95; to: 1.0; duration: control.theme.animationDuration; easing.type: Easing.OutCubic }
        }
        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: control.theme.animationDuration; easing.type: Easing.OutCubic }
            NumberAnimation { property: "scale"; from: 1.0; to: 0.95; duration: control.theme.animationDuration; easing.type: Easing.OutCubic }
        }

        // Reset filtering and restore the selected value when the popup closes.
        onClosed: {
            control.searching = false
            control.editText = control.currentIndex < 0 ? "" : control.currentText
        }

        background: Rectangle {
            radius: control.theme.radius
            color: control.theme.popover
            border.color: control.theme.border
            border.width: 1
        }
        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            boundsBehavior: Flickable.StopAtBounds
            ScrollIndicator.vertical: ScrollIndicator {}

            // Show the empty state when no items match.
            Text {
                anchors.centerIn: parent
                text: qsTr("No items found.")
                color: control.theme.mutedForeground
                font.pixelSize: control.theme.fontSize
                visible: control.matchCount === 0
            }
        }
    }
}
