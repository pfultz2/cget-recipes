cmake_minimum_required(VERSION 2.8)

project (FreeImage)

if(MSVC)
    add_definitions(-D_CRT_SECURE_NO_DEPRECATE)
else()
    add_definitions(-Wno-narrowing)
endif()

find_package(ZLIB REQUIRED)
include_directories(${ZLIB_INCLUDE_DIRS})

find_package(JPEG REQUIRED)
include_directories(${JPEG_INCLUDE_DIR})

find_package(PNG REQUIRED)
include_directories(${PNG_INCLUDE_DIRS})

find_package(TIFF REQUIRED)
include_directories(${TIFF_INCLUDE_DIR})


macro(create_lib NAME)
    file(GLOB SOURCES ${ARGN})
    add_library(${NAME} ${SOURCES})
    install(TARGETS 
    ${NAME}
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
    Source/OpenEXR
    Source/OpenEXR/Half
    Source/OpenEXR/Iex
    Source/OpenEXR/IlmImf
    Source/OpenEXR/IlmThread
    Source/OpenEXR/Imath
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

target_link_libraries(FreeImage
    OpenEXR
    OpenJPEG
    RawLite
    WebP
    ${ZLIB_LIBRARIES}
    ${JPEG_LIBRARIES}
    ${PNG_LIBRARIES}
    ${TIFF_LIBRARIES}
)

# Set default output dirs
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

install(FILES Source/FreeImage.h DESTINATION  "${CMAKE_INSTALL_PREFIX}/include")
