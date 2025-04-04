#ifndef HID_COMMANDER_H
#define HID_COMMANDER_H

#include <QObject>
#include <windows.h>

class HID_Commander : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QString> deviceList READ deviceList WRITE setDeviceList NOTIFY deviceListChanged);
    Q_PROPERTY(int activeDeviceIndex READ activeDeviceIndex WRITE setActiveDeviceIndex NOTIFY activeDeviceIndexChanged);

public:
    explicit HID_Commander(QObject *parent = nullptr);
    static HID_Commander* instance();
    
    Q_INVOKABLE QString getFirmwareVerisonByIndex(int index);
    Q_INVOKABLE QString sendMessageToIndex(int index, QString message);
    Q_INVOKABLE int getNumberOfDevices();
    Q_INVOKABLE QString getDeviceNameByIndex(int index);
    Q_INVOKABLE bool openDeviceByIndex(int index);
    Q_INVOKABLE bool closeActiveDevice();

    QList<QString> deviceList() const { return m_deviceList; }
    void setDeviceList(QList<QString> deviceList) { m_deviceList = deviceList; emit deviceListChanged(); }
    int activeDeviceIndex() const { return m_activeDeviceIndex; }
    void setActiveDeviceIndex(int index) { m_activeDeviceIndex = index; emit activeDeviceIndexChanged(); }

private:
    QList<QString> m_deviceList;
    int m_activeDeviceIndex = -1;

    HANDLE m_hDevice;

    // Pointer functions for DLL
    typedef int (*GetCommanderHIDnumberFunc)();
    typedef void (*GetCommanderHIDNameFunc)(int index, char* name);
    typedef void (*OpenCommanderHIDFunc)(HANDLE* pHandle, char* name);
    typedef void (*CloseCommanderHIDFunc)(HANDLE handle);
    typedef void (*SendReceiveCommanderHIDFunc)(HANDLE handle, char* command, char* reply);

    GetCommanderHIDnumberFunc getCommanderHIDnumber = nullptr;
    GetCommanderHIDNameFunc getCommanderHIDName = nullptr;
    OpenCommanderHIDFunc openCommanderHID = nullptr;
    CloseCommanderHIDFunc closeCommanderHID = nullptr;
    SendReceiveCommanderHIDFunc sendReceiveCommanderHID = nullptr;

signals:
    void deviceListChanged();
    void activeDeviceIndexChanged();
};

#endif // HID_COMMANDER_H
