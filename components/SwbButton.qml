import QtQuick
import QtQuick.Controls.Basic

Button {
    id: control

    property SwbStyle theme: SwbStyle {}

    // Control properties.
    property string variant: "default"  // default | destructive | outline | secondary | ghost | link
    property string size: "default"     // sm | default | lg

    // Resolve the fill from the variant; destructive uses a subtle red and hover increases contrast.
    property color bgColor: {
        switch (variant) {
        case "destructive": return hovered ? control.theme.destructiveBgHover : control.theme.destructiveBg
        case "secondary":   return hovered ? control.theme.secondaryHover : control.theme.secondary
        case "outline":     return hovered ? control.theme.accent : control.theme.background
        case "ghost":       return hovered ? control.theme.accent : control.theme.withAlpha(control.theme.accent, 0)
        case "link":        return "transparent"
        default:            return hovered ? control.theme.primaryHover : control.theme.primary
        }
    }
    property color textColor: {
        switch (variant) {
        case "destructive": return control.theme.destructive
        case "secondary":   return control.theme.secondaryForeground
        case "outline":
        case "ghost":       return control.theme.foreground
        case "link":        return control.theme.primary
        default:            return control.theme.primaryForeground
        }
    }

    // Support sm, default, and lg heights; sm uses a smaller radius.
    property int controlHeight: size === "sm" ? control.theme.controlHeightSm
                                       : size === "lg" ? control.theme.controlHeightLg
                                       : control.theme.controlHeight
    property int radius: size === "sm" ? control.theme.radiusSm : control.theme.radius
    horizontalPadding: 10
    verticalPadding: 0

    hoverEnabled: true
    font.pixelSize: size === "sm" ? control.theme.fontSizeSm : control.theme.fontSize
    font.weight: control.theme.fontWeight
    opacity: enabled ? 1.0 : 0.5

    contentItem: Text {
        text: control.text
        font.pixelSize: control.font.pixelSize
        font.weight: control.font.weight
        font.underline: control.variant === "link" && control.hovered
        color: control.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        Behavior on color { ColorAnimation { duration: control.theme.animationDuration } }
    }

    background: Rectangle {
        implicitHeight: control.controlHeight
        radius: control.radius
        color: control.bgColor
        // Reserve a 1px border for every variant and reveal it for outline.
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
