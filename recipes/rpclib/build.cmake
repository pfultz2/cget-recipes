cmake_minimum_required(VERSION 2.8)

find_package(cget-recipe-utils)

patch_file(${CGET_CMAKE_ORIGINAL_SOURCE_FILE} "{PROJECT_BINARY_DIR}/version.h" "{PROJECT_SOURCE_DIR}/include/rpc/version.h")
include(${CGET_CMAKE_ORIGINAL_SOURCE_FILE})