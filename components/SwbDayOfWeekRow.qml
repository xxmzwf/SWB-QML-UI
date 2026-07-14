pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic

DayOfWeekRow {
    id: control

    property SwbStyle theme: SwbStyle {}

    spacing: control.theme.calendarSpacing
    padding: 0

    // Muted weekday abbreviations aligned with the month-grid columns.
    delegate: Text {
        required property string shortName
        text: shortName
        width: control.theme.calendarCellSize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 12
        font.weight: Font.Normal
        color: control.theme.mutedForeground
    }
}
