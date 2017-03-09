cmake_minimum_required(VERSION 2.8)
project(lapack)

include(${CGET_CMAKE_ORIGINAL_SOURCE_FILE})

# Post install script to make config available for cmake to find
file(WRITE cget-post-install/post-install.cmake "
file(GLOB LAPACK_CMAKE_FILES ${CMAKE_INSTALL_FULL_LIBDIR}/cmake/lapack-${LAPACK_VERSION}/*.cmake)
file(INSTALL \${LAPACK_CMAKE_FILES} DESTINATION ${CMAKE_INSTALL_FULL_LIBDIR}/cmake/lapack/)
file(GLOB CBLAS_CMAKE_FILES ${CMAKE_INSTALL_FULL_LIBDIR}/cmake/cblas-${LAPACK_VERSION}/*.cmake)
file(INSTALL \${CBLAS_CMAKE_FILES} DESTINATION ${CMAKE_INSTALL_FULL_LIBDIR}/cmake/cblas/)
")

file(WRITE cget-post-install/CMakeLists.txt "
install(SCRIPT post-install.cmake)
")
add_subdirectory(cget-post-install)
