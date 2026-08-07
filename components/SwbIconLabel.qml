import QtQuick
import QtQuick.Controls.impl
import QtQuick.Controls.Basic
import QtQuick.VectorImage
import QtQuick.Window

// IconLabel-compatible content item that keeps text native while rendering
// SVG icons as curves instead of through the Controls texture icon path.
Item {
    id: root

    property var icon
    property string text: ""
    property font font
    property color color: "black"
    property int display: AbstractButton.TextBesideIcon
    property int alignment: Qt.AlignCenter
    property bool mirrored: false
    property real spacing: 0

    readonly property string iconUrl: icon && icon.source ? icon.source.toString() : ""
    readonly property bool hasIconSource: iconUrl.length > 0
    readonly property bool isSvgSource: {
        const normalizedUrl = iconUrl.toLowerCase()
        return normalizedUrl.endsWith(".svg") || normalizedUrl.endsWith(".svgz")
            || normalizedUrl.indexOf(".svg?") >= 0 || normalizedUrl.indexOf(".svg#") >= 0
            || normalizedUrl.indexOf(".svgz?") >= 0 || normalizedUrl.indexOf(".svgz#") >= 0
    }
    readonly property bool hasAbsoluteIconSource: iconUrl.startsWith("/")
                                                   || iconUrl.startsWith("\\")
                                                   || iconUrl.startsWith(":/")
                                                   || /^[a-z][a-z0-9+.-]*:/i.test(iconUrl)
    readonly property bool canRenderSvgDirectly: isSvgSource && hasAbsoluteIconSource
    readonly property bool hasIconName: !!(icon && icon.name && icon.name.length > 0)
    readonly property bool hasIcon: hasIconSource || hasIconName
    readonly property bool showIcon: hasIcon && display !== AbstractButton.TextOnly
    readonly property bool showText: text.length > 0 && display !== AbstractButton.IconOnly
    readonly property real iconWidth: showIcon && icon ? Math.max(0, icon.width) : 0
    readonly property real iconHeight: showIcon && icon ? Math.max(0, icon.height) : 0
    readonly property real textWidth: showText ? textLabel.implicitWidth : 0
    readonly property real textHeight: showText ? textLabel.implicitHeight : 0
    readonly property real groupWidth: {
        if (display === AbstractButton.TextBesideIcon)
            return iconWidth + textWidth + (showIcon && showText ? spacing : 0)
        if (display === AbstractButton.TextUnderIcon)
            return Math.max(iconWidth, textWidth)
        return showIcon ? iconWidth : textWidth
    }
    readonly property real groupHeight: {
        if (display === AbstractButton.TextUnderIcon)
            return iconHeight + textHeight + (showIcon && showText ? spacing : 0)
        return Math.max(iconHeight, textHeight)
    }
    readonly property bool hasExplicitIconColor: !!(icon && icon.color && icon.color.a > 0)

    implicitWidth: groupWidth
    implicitHeight: groupHeight
    clip: true

    Item {
        id: group
        width: root.groupWidth
        height: root.groupHeight

        x: {
            if (root.alignment & Qt.AlignLeft)
                return 0
            if (root.alignment & Qt.AlignRight)
                return root.width - width
            return (root.width - width) / 2
        }
        y: {
            if (root.alignment & Qt.AlignTop)
                return 0
            if (root.alignment & Qt.AlignBottom)
                return root.height - height
            return (root.height - height) / 2
        }

        Item {
            id: iconItem
            width: root.iconWidth
            height: root.iconHeight
            x: {
                if (root.display === AbstractButton.TextBesideIcon)
                    return root.mirrored ? group.width - width : 0
                if (root.display === AbstractButton.TextUnderIcon)
                    return (group.width - width) / 2
                return 0
            }
            y: root.display === AbstractButton.TextUnderIcon
               ? 0
               : (group.height - height) / 2
            visible: root.showIcon

            VectorImage {
                id: vectorIcon
                anchors.fill: parent
                source: root.icon ? root.icon.source : ""
                fillMode: VectorImage.PreserveAspectFit
                preferredRendererType: VectorImage.CurveRenderer
                visible: root.canRenderSvgDirectly && !root.hasExplicitIconColor
            }

            IconImage {
                anchors.fill: parent
                source: root.icon ? root.icon.source : ""
                color: root.icon ? root.icon.color : root.color
                sourceSize.width: Math.ceil(width * Screen.devicePixelRatio)
                sourceSize.height: Math.ceil(height * Screen.devicePixelRatio)
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: false
                visible: root.canRenderSvgDirectly && root.hasExplicitIconColor
            }

            // Preserve named icons and non-SVG sources exactly as before.
            IconLabel {
                anchors.fill: parent
                display: IconLabel.IconOnly
                icon: root.icon
                color: root.color
                visible: root.showIcon && !root.canRenderSvgDirectly
            }
        }

        IconLabel {
            id: textLabel
            width: root.textWidth
            height: root.textHeight
            x: {
                if (root.display === AbstractButton.TextBesideIcon)
                    return root.mirrored ? 0 : root.iconWidth + (root.showIcon ? root.spacing : 0)
                if (root.display === AbstractButton.TextUnderIcon)
                    return (group.width - width) / 2
                return 0
            }
            y: root.display === AbstractButton.TextUnderIcon
               ? root.iconHeight + (root.showIcon ? root.spacing : 0)
               : (group.height - height) / 2
            display: IconLabel.TextOnly
            text: root.text
            font: root.font
            color: root.color
            visible: root.showText
            Behavior on color { ColorAnimation { duration: 120 } }
        }
    }
}
