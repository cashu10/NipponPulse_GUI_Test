#include "hid_commander.h"
#include "hid_commander_commands.h"
#include <QLibrary>
#include <QDebug>

HID_Commander::HID_Commander(QObject *parent)
    : QObject{parent}
{
    qDebug() << "HID_Commander constructor called.";

    // Load the DLL
    QLibrary library("CMDHidApi64.dll");

    qDebug() << "Loading DLL:" << library.fileName();

    if (!library.load()) {
        qDebug() << "Failed to load DLL:" << library.errorString();
        return;
    }

    // Resolve functions from the DLL
    getCommanderHIDnumber = (GetCommanderHIDnumberFunc)library.resolve("GetCommanderHIDnumber");
    if (!getCommanderHIDnumber) {
        qDebug() << "Failed to resolve GetCommanderHIDnumber";
        return;
    }

    getCommanderHIDName = (GetCommanderHIDNameFunc)library.resolve("GetCommanderHIDName");
    if (!getCommanderHIDName) {
        qDebug() << "Failed to resolve GetCommanderHIDName";
        return;
    }

    openCommanderHID = (OpenCommanderHIDFunc)library.resolve("OpenCommanderHID");
    if (!openCommanderHID) {
        qDebug() << "Failed to resolve OpenCommanderHID";
        return;
    }

    closeCommanderHID = (CloseCommanderHIDFunc)library.resolve("CloseCommanderHID");
    if (!closeCommanderHID) {
        qDebug() << "Failed to resolve CloseCommanderHID";
        return;
    }

    sendReceiveCommanderHID = (SendReceiveCommanderHIDFunc)library.resolve("SendReceiveCommanderHID");
    if (!sendReceiveCommanderHID) {
        qDebug() << "Failed to resolve SendReceiveCommanderHID";
        return;
    }

    qDebug() << "DLL loaded successfully.";
    qDebug() << "Functions resolved successfully.";

    int numDevices = getNumberOfDevices();
    qDebug() << "Number of devices:" << numDevices;

    m_deviceList.clear();
    for (int i = 0; i < numDevices; ++i) {
        char name[256] = {0};
        getCommanderHIDName(i, name);
        m_deviceList.append(QString(name));
    }
    m_activeDeviceIndex = -1;

}

HID_Commander* HID_Commander::instance()
{
    static HID_Commander* m_instance;

    if (!m_instance) {
        m_instance = new HID_Commander();
    }
    return m_instance;
}

QString HID_Commander::getFirmwareVerisonByIndex(int index)
{
    if(openDeviceByIndex(index)) {
        char reply[256] = {0};
        char command[256] = {0};
        strncpy(command, GET_FIRMWARE_VERSION, sizeof(command) - 1);
        sendReceiveCommanderHID(m_hDevice, command, reply);
        return QString(reply);
    }

    return QString();
}

int HID_Commander::getNumberOfDevices()
{
    return getCommanderHIDnumber();
}

QString HID_Commander::getDeviceNameByIndex(int index)
{
    if (index < 0 || index >= getNumberOfDevices()) {
        return QString();
    }
    char name[256] = {0};
    getCommanderHIDName(index, name);
    return QString(name);
}

bool HID_Commander::openDeviceByIndex(int index)
{
    if (index < 0 || index >= getNumberOfDevices()) {
        return false;
    }

    QString deviceName = getDeviceNameByIndex(index);
    if (deviceName.isEmpty()) {
        qDebug() << "Failed to get device name for index:" << index;
        return false;
    }

    openCommanderHID(&m_hDevice, deviceName.toUtf8().data());
    if (m_hDevice == NULL || m_hDevice == INVALID_HANDLE_VALUE) {
        qDebug() << "Failed to open device:" << deviceName;
        return false;
    }

    qDebug() << "Device opened successfully:" << deviceName;
    m_activeDeviceIndex = index;
    return true;
}

bool HID_Commander::closeActiveDevice()
{
    if(m_activeDeviceIndex < 0 || m_activeDeviceIndex >= m_deviceList.size()) {
        qDebug() << "Invalid active device index:" << m_activeDeviceIndex;
        return false;
    }

    if (m_hDevice != NULL && m_hDevice != INVALID_HANDLE_VALUE) {
        closeCommanderHID(m_hDevice);
        m_hDevice = NULL;
        return true;
    }

    qDebug() << "No active device to close.";
    m_activeDeviceIndex = -1;
    return false;
}

