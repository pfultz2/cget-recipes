cmake_minimum_required(VERSION 2.8)
project(tiff C)

# set(tiff_libs_private "liblzma zlib")
file(APPEND libtiff-4.pc.in "
Requires.private: liblzma zlib
")
include(${CGET_CMAKE_ORIGINAL_SOURCE_FILE})
