cmake_minimum_required(VERSION 3.21)
project(SWB-QML-UI VERSION 0.0.1 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)

# Qt installation prefix; override it with -DQT_PATH=...
set(QT_PATH "D:/CodeLibraries/Qt-6.11.1-Static" CACHE PATH "Qt 安装前缀")
list(APPEND CMAKE_PREFIX_PATH "${QT_PATH}")

# Default to Release when no build type is specified.
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "" FORCE)
endif()

# Build shared libraries by default to match a shared Qt installation.
option(BUILD_SHARED_LIBS "构建动态库（关则静态库）" ON)
# Build the example by default only when this is the top-level project.
option(SWB_BUILD_EXAMPLES "编译示例程序" ${PROJECT_IS_TOP_LEVEL})

find_package(Qt6 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.10)

add_subdirectory(components)
if(SWB_BUILD_EXAMPLES)
    add_subdirectory(examples)
endif()
