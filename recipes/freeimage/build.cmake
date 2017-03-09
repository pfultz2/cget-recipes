cmake_minimum_required(VERSION 2.8)

project (FreeImage)

if(MSVC)
    add_definitions(-D_CRT_SECURE_NO_DEPRECATE)
else()
    add_definitions(-Wno-narrowing)
endif()

if(BUILD_SHARED_LIBS)
    set(LINK_TYPE "PRIVATE")
else()
    set(LINK_TYPE "PUBLIC")
endif()

find_package(ZLIB REQUIRED)
find_package(JPEG REQUIRED)
find_package(PNG REQUIRED)
find_package(TIFF REQUIRED)

macro(create_lib NAME)
    file(GLOB SOURCES ${ARGN})
    add_library(${NAME} ${SOURCES})
    target_include_directories(${NAME} ${LINK_TYPE} 
        ${ZLIB_INCLUDE_DIRS}
        ${JPEG_INCLUDE_DIR}
        ${PNG_INCLUDE_DIRS}
        ${TIFF_INCLUDE_DIR})
    target_link_libraries(${NAME} ${LINK_TYPE}
        ${ZLIB_LIBRARIES}
        ${JPEG_LIBRARIES}
        ${PNG_LIBRARIES}
        ${TIFF_LIBRARIES})
    install(TARGETS 
    ${NAME} EXPORT freeimage-targets
    RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" 
    ARCHIVE DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" 
    LIBRARY DESTINATION "${CMAKE_INSTALL_PREFIX}/lib")
endmacro()

# LibOpenJPEG
create_lib(OpenJPEG 
    Source/LibOpenJPEG/bio.c 
    Source/LibOpenJPEG/cio.c 
    Source/LibOpenJPEG/dwt.c 
    Source/LibOpenJPEG/event.c 
    Source/LibOpenJPEG/function_list.c
    Source/LibOpenJPEG/image.c 
    Source/LibOpenJPEG/invert.c
    Source/LibOpenJPEG/j2k.c 
    Source/LibOpenJPEG/jp2.c 
    Source/LibOpenJPEG/mct.c 
    Source/LibOpenJPEG/mqc.c 
    Source/LibOpenJPEG/openjpeg.c 
    Source/LibOpenJPEG/opj_clock.c 
    Source/LibOpenJPEG/pi.c 
    Source/LibOpenJPEG/raw.c 
    Source/LibOpenJPEG/t1.c 
    Source/LibOpenJPEG/t1_generate_luts.c 
    Source/LibOpenJPEG/t2.c 
    Source/LibOpenJPEG/tcd.c 
    Source/LibOpenJPEG/tgt.c
)
if(NOT BUILD_SHARED_LIBS)
    target_compile_definitions(OpenJPEG PUBLIC -DOPJ_STATIC)
endif()

# LibRawLite
create_lib(RawLite 
    Source/LibRawLite/internal/dcraw_common.cpp 
    Source/LibRawLite/internal/dcraw_fileio.cpp 
    Source/LibRawLite/internal/demosaic_packs.cpp
    Source/LibRawLite/src/*.cpp
)
target_include_directories(RawLite PRIVATE Source/LibRawLite/)
target_compile_definitions(RawLite PRIVATE -DLIBRAW_LIBRARY_BUILD -DNO_LCMS)
if(NOT BUILD_SHARED_LIBS)
    target_compile_definitions(RawLite PUBLIC -DLIBRAW_NODLL)
endif()

# LibWebP
create_lib(WebP 
    Source/LibWebP/src/dec/*.c
    Source/LibWebP/src/dsp/cpu.c
    Source/LibWebP/src/dsp/dec.c
    Source/LibWebP/src/dsp/dec_neon.c
    Source/LibWebP/src/dsp/dec_sse2.c
    Source/LibWebP/src/dsp/enc.c
    Source/LibWebP/src/dsp/enc_neon.c
    Source/LibWebP/src/dsp/enc_sse2.c
    Source/LibWebP/src/dsp/lossless.c
    Source/LibWebP/src/dsp/upsampling.c
    Source/LibWebP/src/dsp/upsampling_neon.c
    Source/LibWebP/src/dsp/upsampling_sse2.c
    Source/LibWebP/src/dsp/yuv.c
    Source/LibWebP/enc/dsp/*.c
    Source/LibWebP/utils/*.c
    Source/LibWebP/mux/*.c
    Source/LibWebP/webp/*.c
)

# OpenEXR
create_lib(OpenEXR
    Source/OpenEXR/Half/*.cpp
    Source/OpenEXR/Iex/*.cpp
    Source/OpenEXR/IlmImf/*.cpp
    Source/OpenEXR/IlmThread/*.cpp
    Source/OpenEXR/Imath/*.cpp
)
target_include_directories(OpenEXR PUBLIC 
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Source/OpenEXR>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Source/OpenEXR/Half>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Source/OpenEXR/Iex>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Source/OpenEXR/IlmImf>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Source/OpenEXR/IlmThread>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Source/OpenEXR/Imath>
)

# FreeImage
create_lib(FreeImage 
    Source/DeprecationManager/*.cpp
    Source/FreeImage/BitmapAccess.cpp
    Source/FreeImage/CacheFile.cpp
    Source/FreeImage/ColorLookup.cpp
    Source/FreeImage/Conversion.cpp
    Source/FreeImage/Conversion16_555.cpp
    Source/FreeImage/Conversion16_565.cpp
    Source/FreeImage/Conversion24.cpp
    Source/FreeImage/Conversion32.cpp
    Source/FreeImage/Conversion4.cpp
    Source/FreeImage/Conversion8.cpp
    Source/FreeImage/ConversionFloat.cpp
    Source/FreeImage/ConversionRGBF.cpp
    Source/FreeImage/ConversionRGB16.cpp
    Source/FreeImage/ConversionType.cpp
    Source/FreeImage/ConversionUINT16.cpp
    Source/FreeImage/FreeImage.cpp
    Source/FreeImage/FreeImageIO.cpp
    Source/FreeImage/GetType.cpp
    Source/FreeImage/Halftoning.cpp
    Source/FreeImage/J2KHelper.cpp
    Source/FreeImage/MemoryIO.cpp
    Source/FreeImage/MNGHelper.cpp
    Source/FreeImage/MultiPage.cpp
    Source/FreeImage/NNQuantizer.cpp
    Source/FreeImage/PixelAccess.cpp
    Source/FreeImage/Plugin.cpp
    Source/FreeImage/PluginBMP.cpp
    Source/FreeImage/PluginCUT.cpp
    Source/FreeImage/PluginDDS.cpp
    Source/FreeImage/PluginEXR.cpp
    Source/FreeImage/PluginG3.cpp
    Source/FreeImage/PluginGIF.cpp
    Source/FreeImage/PluginHDR.cpp
    Source/FreeImage/PluginICO.cpp
    Source/FreeImage/PluginIFF.cpp
    Source/FreeImage/PluginJ2K.cpp
    Source/FreeImage/PluginJNG.cpp
    Source/FreeImage/PluginJP2.cpp
    Source/FreeImage/PluginJPEG.cpp
    Source/FreeImage/PluginKOALA.cpp
    # Source/FreeImage/PluginMNG.cpp
    Source/FreeImage/PluginPCD.cpp
    Source/FreeImage/PluginPCX.cpp
    Source/FreeImage/PluginPFM.cpp
    Source/FreeImage/PluginPICT.cpp
    Source/FreeImage/PluginPNG.cpp
    Source/FreeImage/PluginPNM.cpp
    Source/FreeImage/PluginPSD.cpp
    Source/FreeImage/PluginRAS.cpp
    Source/FreeImage/PluginRAW.cpp
    Source/FreeImage/PluginSGI.cpp
    Source/FreeImage/PluginTARGA.cpp
    Source/FreeImage/PluginTIFF.cpp
    Source/FreeImage/PluginWBMP.cpp
    Source/FreeImage/PluginWebP.cpp
    Source/FreeImage/PluginXBM.cpp
    Source/FreeImage/PluginXPM.cpp
    Source/FreeImage/PSDParser.cpp
    Source/FreeImage/TIFFLogLuv.cpp
    Source/FreeImage/tmoColorConvert.cpp
    Source/FreeImage/tmoDrago03.cpp
    Source/FreeImage/tmoFattal02.cpp
    Source/FreeImage/tmoReinhard05.cpp
    Source/FreeImage/ToneMapping.cpp
    Source/FreeImage/WuQuantizer.cpp
    Source/FreeImage/ZLibInterface.cpp
    Source/FreeImageToolkit/*.cpp
    Source/Metadata/*.cpp
)
target_compile_definitions(FreeImage PUBLIC -DFREEIMAGE_LIB)
target_include_directories(FreeImage PRIVATE Source/)
target_include_directories(FreeImage SYSTEM INTERFACE $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/include>)


target_link_libraries(FreeImage ${LINK_TYPE}
    OpenEXR
    OpenJPEG
    RawLite
    WebP
)

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/freeimage-config.cmake.in "
@PACKAGE_INIT@

include(CMakeFindDependencyMacro OPTIONAL RESULT_VARIABLE _CMakeFindDependencyMacro_FOUND)
if (NOT _CMakeFindDependencyMacro_FOUND)
  macro(find_dependency dep)
    if (NOT \${dep}_FOUND)
      set(cmake_fd_version)
      if (\${ARGC} GREATER 1)
        set(cmake_fd_version \${ARGV1})
      endif()
      set(cmake_fd_exact_arg)
      if(\${CMAKE_FIND_PACKAGE_NAME}_FIND_VERSION_EXACT)
        set(cmake_fd_exact_arg EXACT)
      endif()
      set(cmake_fd_quiet_arg)
      if(\${CMAKE_FIND_PACKAGE_NAME}_FIND_QUIETLY)
        set(cmake_fd_quiet_arg QUIET)
      endif()
      set(cmake_fd_required_arg)
      if(\${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED)
        set(cmake_fd_required_arg REQUIRED)
      endif()
      find_package(\${dep} \${cmake_fd_version}
          \${cmake_fd_exact_arg}
          \${cmake_fd_quiet_arg}
          \${cmake_fd_required_arg}
      )
      string(TOUPPER \${dep} cmake_dep_upper)
      if (NOT \${dep}_FOUND AND NOT \${cmake_dep_upper}_FOUND)
        set(\${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE "\${CMAKE_FIND_PACKAGE_NAME} could not be found because dependency \${dep} could not be found.")
        set(${CMAKE_FIND_PACKAGE_NAME}_FOUND False)
        return()
      endif()
      set(cmake_fd_version)
      set(cmake_fd_required_arg)
      set(cmake_fd_quiet_arg)
      set(cmake_fd_exact_arg)
    endif()
  endmacro()
endif()

set_and_check( FREEIMAGE_INCLUDE_DIR \"@PACKAGE_INCLUDE_INSTALL_DIR@\" )
set_and_check( FREEIMAGE_INCLUDE_DIRS \"\${FREEIMAGE_INCLUDE_DIR}\" )
set_and_check( FREEIMAGE_LIB_INSTALL_DIR \"@PACKAGE_LIB_INSTALL_DIR@\" )

")
if(NOT BUILD_SHARED_LIBS)
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/freeimage-config.cmake.in "
find_dependency(ZLIB REQUIRED)
find_dependency(JPEG REQUIRED)
find_dependency(PNG REQUIRED)
find_dependency(TIFF REQUIRED)
")
endif()

file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/freeimage-config.cmake.in "
include( \"\${CMAKE_CURRENT_LIST_DIR}/freeimage-targets.cmake\" )

set(FREEIMAGE_LIBRARY FreeImage)
set(FREEIMAGE_LIBRARIES FreeImage)
")



include( CMakePackageConfigHelpers )
set(INCLUDE_INSTALL_DIR ${CMAKE_INSTALL_PREFIX}/include)
set(LIB_INSTALL_DIR ${CMAKE_INSTALL_PREFIX}/lib)
set(CONFIG_PACKAGE_INSTALL_DIR ${CMAKE_INSTALL_PREFIX}/lib/cmake/freeimage)
configure_package_config_file(
  ${CMAKE_CURRENT_BINARY_DIR}/freeimage-config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/freeimage-config.cmake
  INSTALL_DESTINATION ${CONFIG_PACKAGE_INSTALL_DIR}
  PATH_VARS LIB_INSTALL_DIR INCLUDE_INSTALL_DIR
)

write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/freeimage-config-version.cmake
  VERSION 3.17.0
  COMPATIBILITY SameMajorVersion
)

install( EXPORT freeimage-targets
  DESTINATION
    ${CONFIG_PACKAGE_INSTALL_DIR}
)

install( FILES
  ${CMAKE_CURRENT_BINARY_DIR}/freeimage-config.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/freeimage-config-version.cmake
  DESTINATION
${CONFIG_PACKAGE_INSTALL_DIR} )

# Set default output dirs
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

install(FILES Source/FreeImage.h DESTINATION  "${CMAKE_INSTALL_PREFIX}/include")
