pragma ComponentBehavior: Bound
pragma Translator: "GalleryPage"
import QtQuick
import QtQuick.Layouts
import SwbControls

GalleryCategoryPage {
    id: page

    component Section: GallerySection { filterText: page.filterText }

    Section {
        title: qsTr("TextField")
        Flow {
            Layout.fillWidth: true
            spacing: 12
            SwbTextField { placeholderText: qsTr("Email"); width: 220 }
            SwbTextField { text: qsTr("Prefilled value"); width: 220 }
            SwbTextField { placeholderText: qsTr("Disabled"); enabled: false; width: 220 }
        }
    }

    Section {
        title: qsTr("SearchField")
        Flow {
            Layout.fillWidth: true
            spacing: 12
            SwbSearchField { width: 220 }
            SwbSearchField { text: qsTr("Prefilled query"); width: 220 }
            SwbSearchField { placeholderText: qsTr("Disabled"); enabled: false; width: 220 }
        }
    }

    Section {
        title: qsTr("TextArea")
        Flow {
            Layout.fillWidth: true
            spacing: 12
            SwbTextArea { placeholderText: qsTr("Type your message here."); width: 170 }
            SwbTextArea { text: qsTr("Prefilled multi-line\ncontent example."); width: 170 }
            SwbTextArea { placeholderText: qsTr("Disabled"); enabled: false; width: 170 }
        }
    }

    Section {
        title: qsTr("ComboBox")
        Flow {
            Layout.fillWidth: true
            spacing: 12
            SwbComboBox {
                placeholderText: qsTr("Select a fruit")
                currentIndex: -1
                model: [qsTr("Apple"), qsTr("Banana"), qsTr("Orange"), qsTr("Grape"), qsTr("Watermelon")]
                width: 220
            }
            SwbComboBox {
                model: [qsTr("Light"), qsTr("Dark"), qsTr("System")]
                width: 220
            }
            SwbComboBox {
                model: [qsTr("Disabled")]
                enabled: false
                width: 220
            }
        }
    }

    Section {
        title: qsTr("Slider")
        Flow {
            Layout.fillWidth: true
            spacing: 24
            SwbSlider { value: 0.5; width: 200 }
            SwbSlider { value: 0.3; stepSize: 0.1; width: 200 }
            SwbSlider { value: 0.6; enabled: false; width: 200 }
        }
    }

    Section {
        title: qsTr("RangeSlider")
        Flow {
            Layout.fillWidth: true
            spacing: 24
            SwbRangeSlider { first.value: 0.2; second.value: 0.8; width: 200 }
            SwbRangeSlider { first.value: 0.3; second.value: 0.6; stepSize: 0.1; width: 200 }
            SwbRangeSlider { first.value: 0.25; second.value: 0.75; enabled: false; width: 200 }
        }
    }

    Section {
        title: qsTr("Dial")
        Flow {
            Layout.fillWidth: true
            spacing: 16
            SwbDial { value: 0.3 }
            SwbDial { value: 0.6; stepSize: 0.1 }
            SwbDial { value: 0.8; enabled: false }
        }
    }

    Section {
        title: qsTr("SpinBox")
        Flow {
            Layout.fillWidth: true
            spacing: 12
            SwbSpinBox { from: 0; to: 100; value: 25; width: 140 }
            SwbSpinBox { from: 0; to: 10; value: 5; width: 140 }
            SwbSpinBox { from: 0; to: 10; value: 3; enabled: false; width: 140 }
        }
    }

    Section {
        title: qsTr("DoubleSpinBox")
        Flow {
            Layout.fillWidth: true
            spacing: 12
            SwbDoubleSpinBox { from: 0; to: 10; value: 2.5; stepSize: 0.1; width: 140 }
            SwbDoubleSpinBox { from: 0; to: 1; value: 0.5; stepSize: 0.05; width: 140 }
            SwbDoubleSpinBox { from: 0; to: 100; value: 12.34; stepSize: 0.5; enabled: false; width: 140 }
        }
    }

    Section {
        title: qsTr("Tumbler")
        Flow {
            Layout.fillWidth: true
            spacing: 16
            SwbTumbler { model: 24; height: 128 }
            SwbTumbler { model: 60; height: 128 }
            SwbTumbler {
                model: [qsTr("Sun"), qsTr("Mon"), qsTr("Tue"), qsTr("Wed"), qsTr("Thu"), qsTr("Fri"), qsTr("Sat")]
                height: 128
            }
            SwbTumbler { model: 12; enabled: false; height: 128 }
        }
    }
}
