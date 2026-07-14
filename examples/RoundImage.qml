import QtQuick
import QtQuick.Effects

// Rounded image clipped by a mask; the default radius produces a circular avatar.
Item {
    id: root

    property alias source: img.source
    property real radius: Math.min(width, height) / 2

    Image {
        id: img
        anchors.fill: parent
        visible: false
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
        // Decode raster images on demand and rasterize vectors at twice the display size.
        sourceSize.width: Math.max(48, root.width * 2)
        sourceSize.height: Math.max(48, root.height * 2)
    }

    MultiEffect {
        anchors.fill: parent
        source: img
        maskEnabled: true
        maskSource: mask
    }

    Item {
        id: mask
        anchors.fill: parent
        visible: false
        layer.enabled: true

        Rectangle {
            anchors.fill: parent
            radius: root.radius
        }
    }
}
