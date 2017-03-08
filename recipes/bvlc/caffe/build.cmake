cmake_minimum_required(VERSION 2.8)
project(Caffe C CXX)

# Cmake module to uses hdf5's cmake instead
file(WRITE ${CMAKE_BINARY_DIR}/cmake/modules/FindHDF5.cmake "
find_package(HDF5 NO_MODULE REQUIRED)
include(FindPackageHandleStandardArgs)
set( HDF5_INCLUDE_DIRS ${HDF5_INCLUDE_DIR} )
find_package_handle_standard_args(HDF5
    REQUIRED_VARS HDF5_LIBRARIES HDF5_INCLUDE_DIR
    CONFIG_MODE
)
")
list(APPEND CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR}/cmake/modules)

include(${CGET_CMAKE_ORIGINAL_SOURCE_FILE})
