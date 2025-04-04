cmake_minimum_required(VERSION 3.16)

project(Application VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appApplication
    main.cpp
)

qt_add_qml_module(appApplication
    URI Application
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES
        RESOURCES Components/SliderInput.qml
QML_FILES Views/HID_Commander.qml
SOURCES Src/hid_commander.cpp Src/hid_commander.h
SOURCES Src/hid_commander.cpp Src/hid_commander.h
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appApplication PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appApplication
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appApplication
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appApplication
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
