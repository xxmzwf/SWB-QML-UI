import QtQuick
import QtQuick.Controls.Basic

ProgressBar {
    id: control

    property SwbStyle theme: SwbStyle {}

    implicitWidth: 200
    opacity: enabled ? 1.0 : 0.5

    // Fully rounded, 6px-high secondary track.
    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 6
        radius: height / 2
        color: control.theme.secondary
    }

    // Primary completed segment whose width follows value smoothly.
    contentItem: Item {
        Rectangle {
            visible: !control.indeterminate
            width: control.visualPosition * parent.width
            height: parent.height
            radius: height / 2
            color: control.theme.primary
            Behavior on width { NumberAnimation { duration: control.theme.animationDuration; easing.type: Easing.OutCubic } }
        }

        // Indeterminate progress sweeps a short segment along the track.
        Rectangle {
            id: sweep
            visible: control.indeterminate
            width: parent.width * 0.4
            height: parent.height
            radius: height / 2
            color: control.theme.primary

            NumberAnimation on x {
                running: control.indeterminate && control.visible
                from: -sweep.width
                to: control.width
                duration: 1200
                loops: Animation.Infinite
            }
        }
    }
}
