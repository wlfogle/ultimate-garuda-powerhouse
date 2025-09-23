# Install script for directory: /home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14

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

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/lang/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/3rdparty/kdsingleapplication/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/3rdparty/pybind11/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/src/cmake_install.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "CALAMARES" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Calamares/CalamaresTargets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Calamares/CalamaresTargets.cmake"
         "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/CMakeFiles/Export/6666751cd3ab54d4a57a046f5b186768/CalamaresTargets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Calamares/CalamaresTargets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Calamares/CalamaresTargets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Calamares" TYPE FILE FILES "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/CMakeFiles/Export/6666751cd3ab54d4a57a046f5b186768/CalamaresTargets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Calamares" TYPE FILE FILES "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/CMakeFiles/Export/6666751cd3ab54d4a57a046f5b186768/CalamaresTargets-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "CALAMARES" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Calamares" TYPE FILE FILES
    "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/CalamaresConfig.cmake"
    "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/CalamaresConfigVersion.cmake"
    "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/CMakeModules/CalamaresAddBrandingSubdirectory.cmake"
    "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/CMakeModules/CalamaresAddLibrary.cmake"
    "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/CMakeModules/CalamaresAddModuleSubdirectory.cmake"
    "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/CMakeModules/CalamaresAddPlugin.cmake"
    "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/CMakeModules/CalamaresAddTest.cmake"
    "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/CMakeModules/CalamaresAddTranslations.cmake"
    "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/CMakeModules/CalamaresAutomoc.cmake"
    "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/CMakeModules/CalamaresCheckModuleSelection.cmake"
    "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/CMakeModules/CMakeColors.cmake"
    "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/CMakeModules/FindYAMLCPP.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "CALAMARES" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/share/polkit-1/actions/com.github.calamares.calamares.policy")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/usr/share/polkit-1/actions" TYPE FILE FILES "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/com.github.calamares.calamares.policy")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "CALAMARES" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/applications" TYPE FILE FILES "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/calamares.desktop")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "CALAMARES" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/man/man8" TYPE FILE FILES "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/man/calamares.8")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
if(CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_COMPONENT MATCHES "^[a-zA-Z0-9_.+-]+$")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
  else()
    string(MD5 CMAKE_INST_COMP_HASH "${CMAKE_INSTALL_COMPONENT}")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INST_COMP_HASH}.txt")
    unset(CMAKE_INST_COMP_HASH)
  endif()
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/home/garuda/Projects/ultimate-garuda-powerhouse/installer/calamares/calamares-3.3.14/build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
