# GUI Features

## Requirements
- Single view
    - List connected devices
        - Get devices from DLL
        - List connections in textbox
    - Set background color of label
        - 3 sliders
            - R, G, B
    - Uptime status
        - Display application runtime
        - In a caption bar (page footer)
        - Use a timer
            - Date time functionality not required
    - Retrieve device firmware
        - Button used to request version
        - Get version from DLL
        - Can be displayed in any manner

## Components needed
- Textbox
- Sliders
- Label with background
- Timer
- Footer with text
- Button

## DLL 
- Connect to device
    - Get total number
        - ```GetCommanderHIDnumber()```
    - Get device name by index
        - ```GetCommanderHIDName(int index, char* name)```
    - Open device by name
        ```OpenCommanderHID(HANDLE* pHandle, char* name)```
- Get firmware version
    - ```SendReceiveCommanderHID(HANDLE pHandle, char* command, char* reply);```
    - Firmware version command
        - ```VER```
- Close device
    - ```CloseCommanderHID(HANDLE pHandle)```

### Project Format
- Framework
    - Qt 6.9
- Views
    - Main.qml
        - opens HID_Commander.qml in loader
    - HID_Commander.qml
        - All features are on this page
- Backend
    - main.cpp
        - starts application
        - define HID_Commander class as singleton (can only open its instance)
    - HID_Commander.cpp/h
        - dynamically links to DLL
        - public functions accessible from front-end