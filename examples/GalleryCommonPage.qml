pragma ComponentBehavior: Bound
pragma Translator: "GalleryPage"
import QtQuick
import QtQuick.Layouts
import SwbControls

GalleryCategoryPage {
    id: page

    component Section: GallerySection { filterText: page.filterText }

    Section {
        title: qsTr("Button")
        Flow {
            Layout.fillWidth: true
            spacing: 12
            SwbButton { text: qsTr("Default") }
            SwbButton { text: qsTr("Secondary"); variant: "secondary" }
            SwbButton { text: qsTr("Destructive"); variant: "destructive" }
            SwbButton { text: qsTr("Outline"); variant: "outline" }
            SwbButton { text: qsTr("Ghost"); variant: "ghost" }
            SwbButton { text: qsTr("Link"); variant: "link" }
            SwbButton { text: qsTr("Small"); size: "sm" }
            SwbButton { text: qsTr("Large"); size: "lg" }
        }
    }

    Section {
        title: qsTr("ToolButton")
        Flow {
            Layout.fillWidth: true
            spacing: 12
            SwbToolButton { text: qsTr("B"); checkable: true; checked: true; font.bold: true }
            SwbToolButton { text: qsTr("I"); checkable: true; font.italic: true }
            SwbToolButton { text: qsTr("U"); checkable: true; font.underline: true }
            SwbToolButton { text: qsTr("★"); checkable: true }
            SwbToolButton { text: qsTr("Outline"); variant: "outline" }
            SwbToolButton { text: qsTr("Small"); variant: "outline"; size: "sm" }
            SwbToolButton { text: qsTr("Large"); variant: "outline"; size: "lg" }
            SwbToolButton { text: qsTr("⋯") }
            SwbToolButton { text: qsTr("×"); enabled: false }
            SwbToolButton { text: qsTr("x"); variant: "outline"; enabled: false }
        }
    }

    Section {
        title: qsTr("RoundButton")
        Flow {
            Layout.fillWidth: true
            spacing: 12
            SwbRoundButton { text: qsTr("Default") }
            SwbRoundButton { text: qsTr("Secondary"); variant: "secondary" }
            SwbRoundButton { text: qsTr("Destructive"); variant: "destructive" }
            SwbRoundButton { text: qsTr("Outline"); variant: "outline" }
            SwbRoundButton { text: qsTr("Ghost"); variant: "ghost" }
            SwbRoundButton { text: qsTr("＋") }
            SwbRoundButton { text: qsTr("−"); variant: "secondary" }
            SwbRoundButton { text: qsTr("★"); variant: "outline" }
            SwbRoundButton { text: qsTr("S"); size: "sm" }
            SwbRoundButton { text: qsTr("L"); size: "lg" }
            SwbRoundButton { text: qsTr("×"); enabled: false }
        }
    }

    Section {
        title: qsTr("DelayButton")
        Flow {
            Layout.fillWidth: true
            spacing: 12
            SwbDelayButton { text: qsTr("Hold to confirm"); onActivated: delayStatus.text = qsTr("Confirmed ✓") }
            SwbDelayButton { text: qsTr("Hold to delete"); variant: "destructive"; onActivated: delayStatus.text = qsTr("Deleted") }
            SwbDelayButton { text: qsTr("Small"); size: "sm" }
            SwbDelayButton { text: qsTr("Large"); size: "lg" }
            SwbDelayButton { text: qsTr("Disabled"); enabled: false }
            Text {
                id: delayStatus

                text: qsTr("Press and hold a button")
                color: SwbTheme.mutedForeground
                font.pixelSize: SwbTheme.fontSize
                height: SwbTheme.controlHeight
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    Section {
        title: qsTr("Switch")
        Flow {
            Layout.fillWidth: true
            spacing: 16
            SwbSwitch { text: qsTr("Off by default") }
            SwbSwitch { text: qsTr("On by default"); checked: true }
            SwbSwitch { text: qsTr("Small"); size: "sm" }
            SwbSwitch { text: qsTr("Disabled"); enabled: false }
        }
    }

    Section {
        title: qsTr("CheckBox")
        Flow {
            Layout.fillWidth: true
            spacing: 16
            SwbCheckBox { text: qsTr("Accept terms"); checked: true }
            SwbCheckBox { text: qsTr("Subscribe") }
            SwbCheckBox { text: qsTr("Disabled"); enabled: false }
            SwbCheckBox { text: qsTr("Disabled checked"); enabled: false; checked: true }
        }
    }

    Section {
        title: qsTr("RadioButton")
        Flow {
            Layout.fillWidth: true
            spacing: 16
            SwbRadioButton { text: qsTr("Default"); checked: true }
            SwbRadioButton { text: qsTr("Comfortable") }
            SwbRadioButton { text: qsTr("Compact") }
            SwbRadioButton { text: qsTr("Disabled"); enabled: false }
        }
    }

    Section {
        title: qsTr("Label")
        Flow {
            Layout.fillWidth: true
            spacing: 24
            Column {
                spacing: 6
                SwbLabel { text: qsTr("Username") }
                SwbTextField { placeholderText: qsTr("Username"); width: 200 }
            }
            Column {
                spacing: 6
                SwbLabel { text: qsTr("Disabled"); enabled: false }
                SwbTextField { placeholderText: qsTr("Disabled"); enabled: false; width: 200 }
            }
        }
    }
}
