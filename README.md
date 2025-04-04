# Qt GUI with DLL integration
Repo for the Nippon Pulse GUI test. The task information is located inside the `Docs` folder. This folder also contains a markdown file with a general overview of what the code contains.

## Run Application
- Unzip the `GuiApplication.zip` folder
- Enter the `Desktop_Qt_6_9_0_MinGW_64_bit-Release` folder
- Double click the `appApplication.exe` file
    - All dependency files are located in this folder, so nothing needs to be rebuilt.

## How to use application
- Main section
    - The dropdown will show the connected devices
        - Devices will be listed in index order, but the name will be shown
    - The `Get Firmware` button is used to get the current device's (as selected using the dropdown) firmware version
        - This button will not be active if there are no devices found
    - The text field allows for custom messages to be sent to the device (as selected using the dropdown)
    - Press the `Send Message` button to send the text string from the textfield
    - When either of the `Get Firmware` or `Send Message` buttons are pressed, a popup will appear with the returned value. If there is no returned value, or the device doesn't respond, this pop up will be blank.
        - Click on the `Ok` button, or outside of the popup area and the popup will close.
- Bottom section
    - Sliders to control RGB values
        - Slider or text boxes can be used to set the value from 0-255
    - The rectangle beneath the slider will show the current color
        - This rectangle will update automatically
- Page footer
    - Circle on left shows if there are any connected devices
        - Green -> connected
        - Red -> disconnected
    - Timer on the right shows the application uptime