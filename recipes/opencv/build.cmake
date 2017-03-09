cmake_minimum_required(VERSION 2.8)
project(opencv)

# Cmake module to FindTIFF using pkgconfig
if(NOT BUILD_SHARED_LIBS)
    file(WRITE ${CMAKE_BINARY_DIR}/cmake/modules/FindTIFF.cmake "
find_package(PkgConfig)
pkg_check_modules (TIFF REQUIRED libtiff-4)
set(TIFF_LIBRARY \${TIFF_LDFLAGS_STATIC} CACHE INTERNAL \"\")
set(TIFF_INCLUDE_DIR \${TIFF_INCLUDE_DIRS_STATIC} CACHE INTERNAL \"\")
    ")
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR}/cmake/modules)
endif()

include(${CGET_CMAKE_ORIGINAL_SOURCE_FILE})
