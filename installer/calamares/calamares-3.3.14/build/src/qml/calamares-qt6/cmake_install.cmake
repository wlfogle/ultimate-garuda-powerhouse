# Install script for directory: /home/garuda/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/src/qml/calamares-qt6

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "0")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "CALAMARES" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/calamares/qml/calamares/slideshow" TYPE FILE FILES "/home/garuda/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/src/qml/calamares-qt6/slideshow/BackButton.qml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "CALAMARES" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/calamares/qml/calamares/slideshow" TYPE FILE FILES "/home/garuda/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/src/qml/calamares-qt6/slideshow/ForwardButton.qml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "CALAMARES" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/calamares/qml/calamares/slideshow" TYPE FILE FILES "/home/garuda/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/src/qml/calamares-qt6/slideshow/NavButton.qml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "CALAMARES" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/calamares/qml/calamares/slideshow" TYPE FILE FILES "/home/garuda/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/src/qml/calamares-qt6/slideshow/Presentation.qml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "CALAMARES" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/calamares/qml/calamares/slideshow" TYPE FILE FILES "/home/garuda/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/src/qml/calamares-qt6/slideshow/Slide.qml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "CALAMARES" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/calamares/qml/calamares/slideshow" TYPE FILE FILES "/home/garuda/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/src/qml/calamares-qt6/slideshow/SlideCounter.qml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "CALAMARES" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/calamares/qml/calamares/slideshow" TYPE FILE FILES "/home/garuda/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/src/qml/calamares-qt6/slideshow/qmldir")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "CALAMARES" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/calamares/qml/calamares/slideshow" TYPE FILE FILES "/home/garuda/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/src/qml/calamares-qt6/slideshow/qmldir.license")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/home/garuda/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/src/qml/calamares-qt6/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
