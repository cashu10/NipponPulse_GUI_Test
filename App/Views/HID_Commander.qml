import QtQuick
import QtQuick.Controls
import "../Components"
import HIDCommander 1.0

Item {
    property string popupTextMessage: "no device found"
    id: page

    Column {
        id: contents
        height: parent.height
        width: parent.width * .9
        anchors.horizontalCenter: parent.horizontalCenter

        Column {
            height: parent.height * .75
            width: parent.width
            spacing: 10
            padding: 20
            Row {
                height: deviceList.height
                width: parent.width
                spacing: 10

                Text {
                    width: parent.width * .2
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Connected Devices:"
                }

                ComboBox {
                    id: deviceList
                    height: 20
                    width: parent.width * .4
                    model: HIDCommander.deviceList
                    anchors.verticalCenter: parent.verticalCenter
                }

                Button {
                    id: getFirmwareButton
                    height: 20
                    width: parent.width * .2
                    enabled: deviceList.model !== undefined && deviceList.model.length > 0
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Get Firmware"
                    onClicked: {
                        console.debug("Clicked, get firmware")
                        page.popupTextMessage = HIDCommander.getFirmwareFromIndex(deviceList.currentIndex);
                        popUp.visible = true;
                    }
                }
            }

            Row {
                height: messageInput.height
                width: parent.width
                spacing: 10

                Text {
                    width: parent.width * .2
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Send message:"
                }

                TextField {
                    id: messageInput
                    height: 20
                    width: parent.width * .4
                    anchors.verticalCenter: parent.verticalCenter
                }

                Button {
                    id: sendMessageButton
                    height: 20
                    width: parent.width * .2
                    enabled: deviceList.model !== undefined && deviceList.model.length > 0
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Send Message"
                    onClicked: {
                        console.debug("Clicked, send message")
                        page.popupTextMessage = HIDCommander.sendMessageToIndex(deviceList.currentIndex, messageInput.text);
                        popUp.visible = true;
                    }
                }
            }
        }

        Column {
            property int textWidth: 100

            id: colorPicker
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height * .2
            width: parent.width

            SliderInput {
                id: sliderR
                height: parent.height * .25
                width: parent.width
                value: 128
                label: "RED: "
            }

            SliderInput {
                id: sliderG
                height: parent.height * .25
                width: parent.width
                value: 128
                label: "GREEN: "
            }

            SliderInput {
                id: sliderB
                height: parent.height * .25
                width: parent.width
                value: 128
                label: "BLUE: "
            }

            Rectangle {
                id: colorBox
                anchors.horizontalCenter: parent.horizontalCenter
                height: parent.height * .25
                width: parent.width
                color: Qt.rgba(sliderR.value / 255, sliderG.value / 255, sliderB.value / 255, 1)
                border.color: "black"
                border.width: 1
            }
        }
    }

    Popup {
        id: popUp
        visible: false
        height: parent.height * .6
        width: parent.width * .6
        anchors.centerIn: parent
        contentItem: Rectangle {
            anchors.fill: parent
            color: "lightBlue"
            Text {
                id: popUpText
                anchors.centerIn: parent
                text: page.popupTextMessage
            }
            Button {
                id: confirmButton
                height: 20
                width: 100
                anchors.top: popUpText.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                text: "OK"
                onClicked: {
                    console.debug("Clicked, popup confirm")
                    popUp.visible = false;
                }
            }
        }
    }
}
