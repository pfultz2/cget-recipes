cmake_minimum_required(VERSION 2.8)
project(arrayfire)

# Cmake module to FindFFTW using pkgconfig
file(WRITE ${CMAKE_BINARY_DIR}/cmake/modules/FindFFTW.cmake "
find_package(PkgConfig)
pkg_check_modules (FFTW REQUIRED fftw)
if(BUILD_SHARED_LIBS)
set(FFTW_LIBRARY \${FFTW_LDFLAGS_STATIC} CACHE INTERNAL \"\")
set(FFTW_INCLUDE_DIR \${FFTW_INCLUDE_DIRS_STATIC} CACHE INTERNAL \"\")
else()
set(FFTW_LIBRARY \${FFTW_LDFLAGS} CACHE INTERNAL \"\")
set(FFTW_INCLUDE_DIR \${FFTW_INCLUDE_DIRS} CACHE INTERNAL \"\")
endif()
set(FFTW_INCLUDES \${FFTW_INCLUDE_DIR} CACHE INTERNAL \"\")
set(FFTW_LIBRARIES \${FFTW_LIBRARY} CACHE INTERNAL \"\")
set(FFTW_LIB \${FFTW_LIBRARY} CACHE INTERNAL \"\")
set(FFTWF_LIB \${FFTW_LIBRARY} CACHE INTERNAL \"\")
")

# Cmake module to FindTIFF using pkgconfig
file(WRITE ${CMAKE_BINARY_DIR}/cmake/modules/FindTIFF.cmake "
find_package(PkgConfig)
pkg_check_modules (TIFF REQUIRED libtiff-4)
set(TIFF_LIBRARY \${TIFF_LDFLAGS_STATIC} CACHE INTERNAL \"\")
set(TIFF_INCLUDE_DIR \${TIFF_INCLUDE_DIRS_STATIC} CACHE INTERNAL \"\")
")

# Cmake module to use cblas's cmake instead
file(WRITE ${CMAKE_BINARY_DIR}/cmake/modules/FindCBLAS.cmake "
find_package(cblas NO_MODULE REQUIRED)
include(FindPackageHandleStandardArgs)
set(CBLAS_INCLUDE_DIR \${CBLAS_INCLUDE_DIRS})
set(CBLAS_INCLUDE_FILE \${CBLAS_INCLUDE_DIRS}/cblas.h)
")

# Cmake module to use lapack's cmake instead
file(WRITE ${CMAKE_BINARY_DIR}/cmake/modules/FindLAPACK.cmake "
find_package(lapack NO_MODULE REQUIRED)
set(LAPACK_INCLUDE_DIR \${LAPACK_INCLUDE_DIRS})
set(LAPACK_LIBRARIES \${LAPACK_lapack_LIBRARIES})
")

# # Cmake module to use lapack's cmake instead
# file(WRITE ${CMAKE_BINARY_DIR}/cmake/modules/FindLAPACKE.cmake "
# find_package(lapack NO_MODULE REQUIRED)
# set(LAPACK_INCLUDE_DIR \${LAPACK_INCLUDE_DIRS})
# set(LAPACK_LIBRARIES \${LAPACK_lapack_LIBRARIES})
# ")

# Cmake module to use freeimage's cmake instead
file(WRITE ${CMAKE_BINARY_DIR}/cmake/modules/FindFreeImage.cmake "
find_package(FREEIMAGE NO_MODULE REQUIRED)
include(FindPackageHandleStandardArgs)
set(FREEIMAGE_DYNAMIC_LIBRARY \${FREEIMAGE_LIBRARY} CACHE INTERNAL \"\")
set(FREEIMAGE_STATIC_LIBRARY \${FREEIMAGE_LIBRARY} CACHE INTERNAL \"\")
set(FREEIMAGE_INCLUDE_PATH \${FREEIMAGE_INCLUDE_DIR} CACHE INTERNAL \"\")
")

list(APPEND CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR}/cmake/modules)

if(NOT EXISTS assets/examples)
    file(MAKE_DIRECTORY assets/examples)
endif()

include(${CGET_CMAKE_ORIGINAL_SOURCE_FILE})
