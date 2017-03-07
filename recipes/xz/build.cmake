cmake_minimum_required(VERSION 2.8)

project(lzma C)

function(patch_file FILE MATCH REPLACEMENT)
    message(STATUS "Patch: ${FILE}")
    file(READ ${FILE} CONTENT)
    string(REPLACE 
        "${MATCH}"
        "${REPLACEMENT}" 
        OUTPUT_CONTENT "${CONTENT}")
    file(WRITE ${FILE} "${OUTPUT_CONTENT}")
endfunction()

include ( CheckFunctionExists )
include ( CheckSymbolExists )
include ( CheckIncludeFiles )
include ( CheckStructHasMember )
include ( CheckTypeSize )

set(CONFIG_VARS)
macro(set_config VAR)
    set(${VAR} ${ARGN})
    list(APPEND CONFIG_VARS ${VAR})
endmacro()
macro(lzma_check_include_files INCLUDE VAR)
    check_include_files(${INCLUDE} ${VAR})
    list(APPEND CONFIG_VARS ${VAR})
endmacro()

macro(lzma_check_function_exists FUNC VAR)
    check_function_exists(${FUNC} ${VAR})
    list(APPEND CONFIG_VARS ${VAR})
endmacro()

macro(lzma_check_symbol_exists FUNC FILES VAR)
    check_symbol_exists(${FUNC} ${FILES} ${VAR})
    list(APPEND CONFIG_VARS ${VAR})
endmacro()

macro(lzma_check_struct_has_member STRUCT MEMBER HEADER VAR)
    check_struct_has_member(${STRUCT} ${MEMBER} ${HEADER} ${VAR})
    list(APPEND CONFIG_VARS ${VAR})
endmacro()

lzma_check_include_files(byteswap.h HAVE_BYTESWAP_H)
lzma_check_include_files(CommonCrypto/CommonDigest.h HAVE_COMMONCRYPTO_COMMONDIGEST_H)
lzma_check_include_files(dlfcn.h HAVE_DLFCN_H)
lzma_check_include_files(fcntl.h HAVE_FCNTL_H)
lzma_check_include_files(getopt.h HAVE_GETOPT_H)
lzma_check_include_files(immintrin.h HAVE_IMMINTRIN_H)
lzma_check_include_files(inttypes.h HAVE_INTTYPES_H)
lzma_check_include_files(limits.h HAVE_LIMITS_H)
lzma_check_include_files(memory.h HAVE_MEMORY_H)
lzma_check_include_files(sha256.h HAVE_SHA256_H)
lzma_check_include_files(sha2.h HAVE_SHA2_H)
lzma_check_include_files(stdint.h HAVE_STDINT_H)
lzma_check_include_files(stdlib.h HAVE_STDLIB_H)
lzma_check_include_files(strings.h HAVE_STRINGS_H)
lzma_check_include_files(string.h HAVE_STRING_H)
lzma_check_include_files(sys/byteorder.h HAVE_SYS_BYTEORDER_H)
lzma_check_include_files(sys/capsicum.h HAVE_SYS_CAPSICUM_H)
lzma_check_include_files(sys/endian.h HAVE_SYS_ENDIAN_H)
lzma_check_include_files(sys/param.h HAVE_SYS_PARAM_H)
lzma_check_include_files(sys/stat.h HAVE_SYS_STAT_H)
lzma_check_include_files(sys/time.h HAVE_SYS_TIME_H)
lzma_check_include_files(sys/types.h HAVE_SYS_TYPES_H)
lzma_check_include_files(unistd.h HAVE_UNISTD_H)

lzma_check_symbol_exists(CC_SHA256_CTX "stdlib.h" HAVE_CC_SHA256_CTX)
lzma_check_symbol_exists(CC_SHA256_Init "stdlib.h" HAVE_CC_SHA256_INIT)
lzma_check_symbol_exists(clock_gettime "stdlib.h" HAVE_CLOCK_GETTIME)
lzma_check_symbol_exists(CLOCK_MONOTONIC "stdlib.h" HAVE_DECL_CLOCK_MONOTONIC)
lzma_check_symbol_exists(futimens "stdlib.h" HAVE_FUTIMENS)
lzma_check_symbol_exists(futimes "stdlib.h" HAVE_FUTIMES)
lzma_check_symbol_exists(futimesat "stdlib.h" HAVE_FUTIMESAT)
lzma_check_symbol_exists(getopt_long "stdlib.h" HAVE_GETOPT_LONG)
lzma_check_symbol_exists(posix_fadvise "stdlib.h" HAVE_POSIX_FADVISE)
lzma_check_symbol_exists(pthread_condattr_setclock "stdlib.h" HAVE_PTHREAD_CONDATTR_SETCLOCK)
lzma_check_symbol_exists(SHA256Init "stdlib.h" HAVE_SHA256INIT)
lzma_check_symbol_exists(SHA256_CTX "stdlib.h" HAVE_SHA256_CTX)
lzma_check_symbol_exists(SHA256_Init "stdlib.h" HAVE_SHA256_INIT)
lzma_check_symbol_exists(SHA2_CTX "stdlib.h" HAVE_SHA2_CTX)
lzma_check_symbol_exists(uintptr_t "stdlib.h" HAVE_UINTPTR_T)
lzma_check_symbol_exists(utime "stdlib.h" HAVE_UTIME)
lzma_check_symbol_exists(utimes "stdlib.h" HAVE_UTIMES)
lzma_check_symbol_exists(wcwidth "stdlib.h" HAVE_WCWIDTH)
lzma_check_symbol_exists(_futime "stdlib.h" HAVE__FUTIME)

check_type_size(_Bool _BOOL)
list(APPEND CONFIG_VARS HAVE__BOOL)

lzma_check_struct_has_member(stat st_atimensec "stdlib.h" HAVE_STRUCT_STAT_ST_ATIMENSEC)
lzma_check_struct_has_member(stat st_atimespec.tv_nsec "stdlib.h" HAVE_STRUCT_STAT_ST_ATIMESPEC_TV_NSEC)
lzma_check_struct_has_member(stat st_atim.st__tim.tv_nsec "stdlib.h" HAVE_STRUCT_STAT_ST_ATIM_ST__TIM_TV_NSEC)
lzma_check_struct_has_member(stat st_atim.tv_nsec "stdlib.h" HAVE_STRUCT_STAT_ST_ATIM_TV_NSEC)
lzma_check_struct_has_member(stat st_uatime "stdlib.h" HAVE_STRUCT_STAT_ST_UATIME)

check_type_size(size_t SIZEOF_SIZE_T)

if(UNIX)
    set_config(_POSIX_SOURCE 1)
    set_config(MYTHREAD_POSIX 1)
else()
    set_config(MYTHREAD_VISTA 1)
    set_config(MYTHREAD_WIN95 1)
endif()

patch_file(config.h.in "#undef" "#cmakedefine")
foreach(VAR ${CONFIG_VARS})
    if(${VAR})
        patch_file(config.h.in "#cmakedefine ${VAR}" "#define ${VAR} 1")
    endif()
endforeach()
foreach(VAR SIZEOF_SIZE_T PACKAGE_VERSION MAJOR_VERSION MINOR_VERSION)
    patch_file(config.h.in "#cmakedefine ${VAR}" "#define ${VAR} @${VAR}@")
endforeach()
configure_file(config.h.in ${CMAKE_BINARY_DIR}/config.h)

set(lzma_SOURCES
    src/common/tuklib_cpucores.c
    src/common/tuklib_physmem.c
    src/liblzma/check/check.c
    src/liblzma/check/crc32_fast.c
    src/liblzma/check/crc32_table.c
    src/liblzma/check/crc64_fast.c
    src/liblzma/check/crc64_table.c
    src/liblzma/check/sha256.c
    src/liblzma/common/alone_decoder.c
    src/liblzma/common/alone_encoder.c
    src/liblzma/common/auto_decoder.c
    src/liblzma/common/block_buffer_decoder.c
    src/liblzma/common/block_buffer_encoder.c
    src/liblzma/common/block_decoder.c
    src/liblzma/common/block_encoder.c
    src/liblzma/common/block_header_decoder.c
    src/liblzma/common/block_header_encoder.c
    src/liblzma/common/block_util.c
    src/liblzma/common/common.c
    src/liblzma/common/easy_buffer_encoder.c
    src/liblzma/common/easy_decoder_memusage.c
    src/liblzma/common/easy_encoder.c
    src/liblzma/common/easy_encoder_memusage.c
    src/liblzma/common/easy_preset.c
    src/liblzma/common/filter_buffer_decoder.c
    src/liblzma/common/filter_buffer_encoder.c
    src/liblzma/common/filter_common.c
    src/liblzma/common/filter_decoder.c
    src/liblzma/common/filter_encoder.c
    src/liblzma/common/filter_flags_decoder.c
    src/liblzma/common/filter_flags_encoder.c
    src/liblzma/common/hardware_cputhreads.c
    src/liblzma/common/hardware_physmem.c
    src/liblzma/common/index.c
    src/liblzma/common/index_decoder.c
    src/liblzma/common/index_encoder.c
    src/liblzma/common/index_hash.c
    src/liblzma/common/outqueue.c
    src/liblzma/common/stream_buffer_decoder.c
    src/liblzma/common/stream_buffer_encoder.c
    src/liblzma/common/stream_decoder.c
    src/liblzma/common/stream_encoder.c
    src/liblzma/common/stream_encoder_mt.c
    src/liblzma/common/stream_flags_common.c
    src/liblzma/common/stream_flags_decoder.c
    src/liblzma/common/stream_flags_encoder.c
    src/liblzma/common/vli_decoder.c
    src/liblzma/common/vli_encoder.c
    src/liblzma/common/vli_size.c
    src/liblzma/delta/delta_common.c
    src/liblzma/delta/delta_decoder.c
    src/liblzma/delta/delta_encoder.c
    src/liblzma/lz/lz_decoder.c
    src/liblzma/lz/lz_encoder.c
    src/liblzma/lz/lz_encoder_mf.c
    src/liblzma/lzma/fastpos_table.c
    src/liblzma/lzma/lzma2_decoder.c
    src/liblzma/lzma/lzma2_encoder.c
    src/liblzma/lzma/lzma_decoder.c
    src/liblzma/lzma/lzma_encoder.c
    src/liblzma/lzma/lzma_encoder_optimum_fast.c
    src/liblzma/lzma/lzma_encoder_optimum_normal.c
    src/liblzma/lzma/lzma_encoder_presets.c
    src/liblzma/rangecoder/price_table.c
    src/liblzma/simple/arm.c
    src/liblzma/simple/armthumb.c
    src/liblzma/simple/ia64.c
    src/liblzma/simple/powerpc.c
    src/liblzma/simple/simple_coder.c
    src/liblzma/simple/simple_decoder.c
    src/liblzma/simple/simple_encoder.c
    src/liblzma/simple/sparc.c
    src/liblzma/simple/x86.c
)

set(lzma_HEADERS
    src/common/mythread.h
    src/common/sysdefs.h
    src/common/tuklib_common.h
    src/common/tuklib_config.h
    src/common/tuklib_cpucores.h
    src/common/tuklib_integer.h
    src/common/tuklib_physmem.h
    src/liblzma/api/lzma.h
    src/liblzma/api/lzma/base.h
    src/liblzma/api/lzma/bcj.h
    src/liblzma/api/lzma/block.h
    src/liblzma/api/lzma/check.h
    src/liblzma/api/lzma/container.h
    src/liblzma/api/lzma/delta.h
    src/liblzma/api/lzma/filter.h
    src/liblzma/api/lzma/hardware.h
    src/liblzma/api/lzma/index.h
    src/liblzma/api/lzma/index_hash.h
    src/liblzma/api/lzma/lzma12.h
    src/liblzma/api/lzma/stream_flags.h
    src/liblzma/api/lzma/version.h
    src/liblzma/api/lzma/vli.h
    src/liblzma/check/check.h
    src/liblzma/check/crc32_table_be.h
    src/liblzma/check/crc32_table_le.h
    src/liblzma/check/crc64_table_be.h
    src/liblzma/check/crc64_table_le.h
    src/liblzma/check/crc_macros.h
    src/liblzma/common/alone_decoder.h
    src/liblzma/common/block_buffer_encoder.h
    src/liblzma/common/block_decoder.h
    src/liblzma/common/block_encoder.h
    src/liblzma/common/common.h
    src/liblzma/common/easy_preset.h
    src/liblzma/common/filter_common.h
    src/liblzma/common/filter_decoder.h
    src/liblzma/common/filter_encoder.h
    src/liblzma/common/index.h
    src/liblzma/common/index_encoder.h
    src/liblzma/common/memcmplen.h
    src/liblzma/common/outqueue.h
    src/liblzma/common/stream_decoder.h
    src/liblzma/common/stream_flags_common.h
    src/liblzma/delta/delta_common.h
    src/liblzma/delta/delta_decoder.h
    src/liblzma/delta/delta_encoder.h
    src/liblzma/delta/delta_private.h
    src/liblzma/lz/lz_decoder.h
    src/liblzma/lz/lz_encoder.h
    src/liblzma/lz/lz_encoder_hash.h
    src/liblzma/lz/lz_encoder_hash_table.h
    src/liblzma/lzma/fastpos.h
    src/liblzma/lzma/lzma2_decoder.h
    src/liblzma/lzma/lzma2_encoder.h
    src/liblzma/lzma/lzma_common.h
    src/liblzma/lzma/lzma_decoder.h
    src/liblzma/lzma/lzma_encoder.h
    src/liblzma/lzma/lzma_encoder_private.h
    src/liblzma/rangecoder/price.h
    src/liblzma/rangecoder/range_common.h
    src/liblzma/rangecoder/range_decoder.h
    src/liblzma/rangecoder/range_encoder.h
    src/liblzma/simple/simple_coder.h
    src/liblzma/simple/simple_decoder.h
    src/liblzma/simple/simple_encoder.h
    src/liblzma/simple/simple_private.h
)

include_directories(
    src/common
    src/liblzma/api
    src/liblzma/check
    src/liblzma/common
    src/liblzma/delta
    src/liblzma/lz
    src/liblzma/lzma
    src/liblzma/rangecoder
    src/liblzma/simple
    ${CMAKE_BINARY_DIR}
)

add_definitions(-DHAVE_CONFIG_H=1)
include_directories(${CMAKE_BINARY_DIR})
if (MSVC)
    include_directories(windows)
endif()

# Shared library
if (WIN32 AND BUILD_SHARED_LIBS)
    list(APPEND lzma_SOURCES src/liblzma/liblzma_w32res.rc)
endif()
add_library(lzma ${lzma_SOURCES} ${lzma_HEADERS})
if(BUILD_SHARED_LIBS)
    target_compile_definitions(lzma PRIVATE DLL_EXPORT)
else()
    target_compile_definitions(lzma PRIVATE LZMA_API_STATIC)
endif()


install(TARGETS lzma
    RUNTIME DESTINATION "bin"
    ARCHIVE DESTINATION "lib"
    LIBRARY DESTINATION "lib"
)
install(DIRECTORY src/liblzma/api/ DESTINATION "include" FILES_MATCHING PATTERN "*.h")
