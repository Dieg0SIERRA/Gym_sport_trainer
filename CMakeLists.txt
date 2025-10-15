cmake_minimum_required(VERSION 3.16)

project(GymTracker VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Crear el ejecutable
qt_add_executable(appGymTracker
    main.cpp
    database/databasemanager.h
    database/databasemanager.cpp
)

# Añadir módulo QML
qt_add_qml_module(appGymTracker URI GymTracker VERSION 1.0
    QML_FILES
        Main.qml
        views/components/GenericButton.qml
        views/components/GenericTextField.qml
        views/login/LoginView.qml
        views/login/LogoTitle.qml
        views/login/HelpText.qml
        views/homePage/HomePageView.qml
        views/homePage/SideBar.qml
        views/homePage/Dashboard.qml
        views/homePage/SideBarItem.qml
        views/homePage/CalendarWidget.qml
)

#Search for required Qt packages
find_package(Qt6 REQUIRED COMPONENTS Core Quick Sql)

# Linking Qt libraries
target_link_libraries(appGymTracker PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Sql
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appGymTracker PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appGymTracker
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

include(GNUInstallDirs)
install(TARGETS appGymTracker
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
