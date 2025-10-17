cmake_minimum_required(VERSION 3.16)

project(GymTracker VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#Search for required Qt packages
find_package(Qt6 REQUIRED COMPONENTS Core Quick Sql)

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

# ============================================
# INSTALL CONFIGURATION
# ============================================

include(GNUInstallDirs)
install(TARGETS appGymTracker
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# Install the Qt dependencies (DLLs on Windows, libraries on Linux/Mac)
if(WIN32)
    # Obtain the path to windeployqt
    get_target_property(QMAKE_EXECUTABLE Qt6::qmake IMPORTED_LOCATION)
    get_filename_component(QT_BIN_DIR "${QMAKE_EXECUTABLE}" DIRECTORY)
    find_program(WINDEPLOYQT_EXECUTABLE windeployqt HINTS "${QT_BIN_DIR}")

    if(WINDEPLOYQT_EXECUTABLE)
        # Run windeployqt after installation
        install(CODE "
            execute_process(
                COMMAND \"${WINDEPLOYQT_EXECUTABLE}\"
                    --qmldir \"${CMAKE_SOURCE_DIR}\"
                    --no-translations
                    \"\${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR}/appGymTracker.exe\"
            )
        " COMPONENT Runtime)
    else()
        message(WARNING "windeployqt no encontrado. Las DLLs de Qt deberán copiarse manualmente.")
    endif()
endif()

# For Linux: use linuxdeploy or copy 
if(UNIX AND NOT APPLE)
    # Install Qt shared libraries
    install(CODE "
        file(GET_RUNTIME_DEPENDENCIES
            EXECUTABLES \${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR}/appGymTracker
            RESOLVED_DEPENDENCIES_VAR RESOLVED_DEPS
            UNRESOLVED_DEPENDENCIES_VAR UNRESOLVED_DEPS
        )
        foreach(DEP \${RESOLVED_DEPS})
            file(INSTALL
                DESTINATION \"\${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}\"
                TYPE SHARED_LIBRARY
                FILES \"\${DEP}\"
            )
        endforeach()
    ")
endif()

# For macOS: use macdeployqt
if(APPLE)
    get_target_property(QMAKE_EXECUTABLE Qt6::qmake IMPORTED_LOCATION)
    get_filename_component(QT_BIN_DIR "${QMAKE_EXECUTABLE}" DIRECTORY)
    find_program(MACDEPLOYQT_EXECUTABLE macdeployqt HINTS "${QT_BIN_DIR}")

    if(MACDEPLOYQT_EXECUTABLE)
        install(CODE "
            execute_process(
                COMMAND \"${MACDEPLOYQT_EXECUTABLE}\"
                    \"\${CMAKE_INSTALL_PREFIX}/appGymTracker.app\"
                    -qmldir=\"${CMAKE_SOURCE_DIR}\"
            )
        " COMPONENT Runtime)
    else()
        message(WARNING "macdeployqt no encontrado.")
    endif()
endif()

# Install additional QML files if necessary
# (qt_add_qml_module already handles this automatically)

# Create a clean installation directory
set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE PATH "Installation Directory" FORCE)

message(STATUS " The application will be installed in: ${CMAKE_INSTALL_PREFIX}")
