import QtQuick
import QtQuick.Controls.impl
import QtQuick.Controls.Basic
import QtQuick.Effects
import QtQuick.VectorImage

ToolButton {
    id: control

    property SwbStyle theme: SwbStyle {}

    // Control properties.
    property string variant: "default"  // default | outline
    property string size: "default"     // sm | default | lg
    property int alignment: Qt.AlignCenter  // Qt.Alignment flags placing the icon and text in the button.

    // Resolve the fill from the variant and checked state; checked and hovered buttons use accent.
    property color bgColor: {
        if (control.checked)
            return control.hovered ? control.theme.accentHover : control.theme.accent
        switch (variant) {
        case "outline": return control.hovered ? control.theme.accent : control.theme.background
        // Use transparent accent instead of black transparent so transitions only change alpha.
        default:        return control.hovered ? control.theme.accent : control.theme.withAlpha(control.theme.accent, 0)
        }
    }
    property color textColor: control.checked ? control.theme.accentForeground : control.theme.foreground

    // Support sm, default, and lg heights; sm uses a smaller radius.
    property int controlHeight: size === "sm" ? control.theme.controlHeightSm
                                       : size === "lg" ? control.theme.controlHeightLg
                                       : control.theme.controlHeight
    property int radius: size === "sm" ? control.theme.radiusSm : control.theme.radius

    padding: 6
    spacing: 6
    icon.width: control.theme.iconSize
    icon.height: control.theme.iconSize

    hoverEnabled: enabled  // Disabled controls ignore hover to avoid a fill beneath reduced opacity.
    font.pixelSize: size === "sm" ? control.theme.fontSizeSm : control.theme.fontSize
    font.weight: control.theme.fontWeight
    opacity: enabled ? 1.0 : 0.5

    // Icon-only buttons collapse to a square while retaining a full click target.
    implicitWidth: Math.max(controlHeight, implicitContentWidth + leftPadding + rightPadding)

    // IconLabel's internal icon image is texture-backed. Keep its text and
    // fallback behavior, but render SVG sources through VectorImage's curve
    // renderer so small line icons remain sharp at high-DPI sizes.
    contentItem: Item {
        id: content

        readonly property bool hasText: control.text.length > 0
        readonly property string iconUrl: control.icon.source.toString()
        readonly property bool hasIconSource: iconUrl.length > 0
        readonly property bool isSvgSource: {
            const normalizedUrl = iconUrl.toLowerCase()
            return normalizedUrl.endsWith(".svg") || normalizedUrl.endsWith(".svgz")
                || normalizedUrl.indexOf(".svg?") >= 0 || normalizedUrl.indexOf(".svg#") >= 0
                || normalizedUrl.indexOf(".svgz?") >= 0 || normalizedUrl.indexOf(".svgz#") >= 0
        }
        readonly property bool hasIconName: control.icon.name.length > 0
        readonly property bool hasIcon: hasIconSource || hasIconName
        readonly property bool showIcon: hasIcon && control.display !== AbstractButton.TextOnly
        readonly property bool showText: hasText && control.display !== AbstractButton.IconOnly
        readonly property real iconWidth: showIcon ? Math.max(0, control.icon.width) : 0
        readonly property real iconHeight: showIcon ? Math.max(0, control.icon.height) : 0
        readonly property real textWidth: showText ? textLabel.implicitWidth : 0
        readonly property real textHeight: showText ? textLabel.implicitHeight : 0
        readonly property real groupWidth: {
            if (control.display === AbstractButton.TextBesideIcon)
                return iconWidth + textWidth + (showIcon && showText ? control.spacing : 0)
            if (control.display === AbstractButton.TextUnderIcon)
                return Math.max(iconWidth, textWidth)
            return showIcon ? iconWidth : textWidth
        }
        readonly property real groupHeight: {
            if (control.display === AbstractButton.TextUnderIcon)
                return iconHeight + textHeight + (showIcon && showText ? control.spacing : 0)
            return Math.max(iconHeight, textHeight)
        }
        readonly property bool hasExplicitIconColor: control.icon.color.a > 0

        implicitWidth: groupWidth
        implicitHeight: groupHeight
        // A ToolButton may be narrower than its natural icon + text width
        // (for example when a side navigation pane is resized). Keep the
        // content inside the control instead of letting it paint over the
        // neighboring pane.
        clip: true

        Item {
            id: group

            width: content.groupWidth
            height: content.groupHeight
            x: {
                if (control.alignment & Qt.AlignLeft)
                    return 0
                if (control.alignment & Qt.AlignRight)
                    return content.width - width
                return (content.width - width) / 2
            }
            y: {
                if (control.alignment & Qt.AlignTop)
                    return 0
                if (control.alignment & Qt.AlignBottom)
                    return content.height - height
                return (content.height - height) / 2
            }

            Item {
                id: iconItem

                width: content.iconWidth
                height: content.iconHeight
                x: {
                    if (control.display === AbstractButton.TextBesideIcon)
                        return control.mirrored ? group.width - width : 0
                    if (control.display === AbstractButton.TextUnderIcon)
                        return (group.width - width) / 2
                    return 0
                }
                y: control.display === AbstractButton.TextUnderIcon
                   ? 0
                   : (group.height - height) / 2
                visible: content.showIcon

                VectorImage {
                    id: vectorIcon

                    anchors.fill: parent
                    source: control.icon.source
                    fillMode: VectorImage.PreserveAspectFit
                    preferredRendererType: VectorImage.CurveRenderer
                    // Keep the source visible for ShaderEffectSource to capture
                    // it when an explicit icon color is requested; hideSource
                    // takes care of suppressing the direct copy in that case.
                    visible: content.isSvgSource
                }

                // Preserve the existing icon.color API without affecting the
                // direct VectorImage path used by the common (untinted) case.
                ShaderEffectSource {
                    id: coloredIconSource

                    anchors.fill: parent
                    sourceItem: vectorIcon
                    hideSource: content.hasExplicitIconColor
                    live: true
                    visible: content.isSvgSource && content.hasExplicitIconColor
                }

                MultiEffect {
                    anchors.fill: parent
                    source: coloredIconSource
                    colorization: content.hasExplicitIconColor ? 1.0 : 0.0
                    colorizationColor: control.icon.color
                    visible: content.isSvgSource && content.hasExplicitIconColor
                }

                // Non-SVG sources and named icons retain the original
                // IconLabel implementation as a compatibility fallback.
                IconLabel {
                    anchors.fill: parent
                    display: IconLabel.IconOnly
                    icon: control.icon
                    color: control.textColor
                    visible: !content.isSvgSource
                }
            }

            IconLabel {
                id: textLabel

                width: content.textWidth
                height: content.textHeight
                x: {
                    if (control.display === AbstractButton.TextBesideIcon)
                        return control.mirrored ? 0 : content.iconWidth + (content.showIcon ? control.spacing : 0)
                    if (control.display === AbstractButton.TextUnderIcon)
                        return (group.width - width) / 2
                    return 0
                }
                y: control.display === AbstractButton.TextUnderIcon
                   ? content.iconHeight + (content.showIcon ? control.spacing : 0)
                   : (group.height - height) / 2
                display: IconLabel.TextOnly
                text: control.text
                font: control.font
                color: control.textColor
                visible: content.showText
                Behavior on color { ColorAnimation { duration: control.theme.animationDuration } }
            }
        }
    }

    background: Rectangle {
        implicitWidth: control.controlHeight
        implicitHeight: control.controlHeight
        radius: control.radius
        color: control.bgColor
        // Outline reveals the border color; other variants keep a transparent placeholder.
        border.color: control.variant === "outline" ? control.theme.border : "transparent"
        border.width: 1
        Behavior on color { ColorAnimation { duration: control.theme.animationDuration } }

        // Focus ring.
        Rectangle {
            anchors.fill: parent
            anchors.margins: -control.theme.focusRingWidth
            radius: parent.radius + control.theme.focusRingWidth
            color: "transparent"
            border.color: control.theme.focusRing
            border.width: control.theme.focusRingWidth
            visible: control.visualFocus
        }
    }
}
