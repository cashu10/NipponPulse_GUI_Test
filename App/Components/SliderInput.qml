import QtQuick
import QtQuick.Controls

Row {
    property alias value: slider.value
    property alias label: label.text
    spacing: 10

    Slider {
        id: slider
        width: parent.width * .5
        from: 0
        to: 255
        stepSize: 1
        value: 128
        onValueChanged: {
            textField.text = slider.value.toString();
        }
    }

    Text {
        id: label
        anchors.verticalCenter: slider.verticalCenter
        width: parent.width * .2
    }

    TextField {
        id: textField
        width: parent.width * .2
        anchors.verticalCenter: slider.verticalCenter
        inputMethodHints: Qt.ImhDigitsOnly // Restrict input to numbers only
        text: slider.value.toString()
        onTextChanged: {
            const newValue = parseInt(text);
            if (!isNaN(newValue) && newValue >= slider.from && newValue <= slider.to) {
                slider.value = newValue;
            }
        }
    }
}
