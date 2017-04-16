cmake_minimum_required(VERSION 2.8)

project(lzma C)

find_package(cget-recipe-utils)

ac_init("XZ Utils" 5.2.3)
ac_check_headers(minix/config.h)
ac_header_stdc()
ac_check_funcs(clock_gettime pthread_condattr_setclock)
ac_check_decls("#include <time.h>" CLOCK_MONOTONIC)
ac_check_headers(dlfcn.h)
ac_check_headers(fcntl.h limits.h sys/time.h)
ac_check_headers(immintrin.h)
ac_header_stdbool()
ac_check_types("" _Bool)
ac_check_type(uintptr_t "")
ac_check_sizeof(size_t)
ac_check_members("
    struct stat.st_atim.tv_nsec,
    struct stat.st_atimespec.tv_nsec,
    struct stat.st_atimensec,
    struct stat.st_uatime,
    struct stat.st_atim.st__tim.tv_nsec" "")
ac_check_member("struct stat.st_atim.tv_nsec" "")
ac_check_member("struct stat.st_atimespec.tv_nsec" "")
ac_check_member("struct stat.st_atimensec" "")
ac_check_member("struct stat.st_uatime" "")
ac_check_member("struct stat.st_atim.st__tim.tv_nsec" "")
ac_sys_largefile()
ac_c_bigendian()
ac_check_headers(getopt.h)
ac_check_funcs(getopt_long)
ac_check_decl(optreset "#include <getopt.h>")
ac_check_funcs(futimens futimes futimesat utimes _futime utime)
ac_check_funcs(posix_fadvise)
ac_check_decls("#include <errno.h>" program_invocation_name)
ac_check_decl(program_invocation_name "#include <errno.h>")
ac_check_headers(byteswap.h sys/endian.h sys/byteorder.h)
ac_check_headers(sys/param.h)
ac_check_funcs(wcwidth)
ac_check_headers(CommonCrypto/CommonDigest.h sha256.h sha2.h)
ac_check_types("#ifdef HAVE_SYS_TYPES_H
              # include <sys/types.h>
              #endif
              #ifdef HAVE_COMMONCRYPTO_COMMONDIGEST_H
              # include <CommonCrypto/CommonDigest.h>
              #endif
              #ifdef HAVE_SHA256_H
              # include <sha256.h>
              #endif
              #ifdef HAVE_SHA2_H
              # include <sha2.h>
              #endif" CC_SHA256_CTX SHA256_CTX SHA2_CTX)
ac_check_funcs(CC_SHA256_Init SHA256Init SHA256_Init)
ac_check_decl(_mm_movemask_epi8 "#ifdef HAVE_IMMINTRIN_H
#include <immintrin.h>
#endif")
ac_check_headers(sys/capsicum.h)
ac_check_decl(cap_rights_limit "#include <sys/capability.h>")
ac_search_libs("HAVE_CLOCK_GETTIME" clock_gettime rt)
ac_search_libs("" SHA256Init md)
ac_search_libs("" SHA256_Init md)

if(UNIX)
    set(MYTHREAD_POSIX 1)
else()
    set(MYTHREAD_VISTA 1)
    set(MYTHREAD_WIN95 1)
endif()

ac_config_header(config.h.in ${CMAKE_BINARY_DIR}/config.h)

if(NOT HAVE_CC_SHA256_INIT OR HAVE_SHA256_INIT OR HAVE_SHA256INIT)
    set(SHA256_SRC src/liblzma/check/sha256.c)
endif()

set(lzma_SOURCES
    src/common/tuklib_cpucores.c
    src/common/tuklib_physmem.c
    src/liblzma/check/check.c
    src/liblzma/check/crc32_fast.c
    src/liblzma/check/crc32_table.c
    src/liblzma/check/crc64_fast.c
    src/liblzma/check/crc64_table.c
    # src/liblzma/check/sha256.c
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
    ${SHA256_SRC}
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

set(prefix ${CMAKE_INSTALL_PREFIX})
set(exec_prefix ${CMAKE_INSTALL_PREFIX}/bin)
set(libdir ${CMAKE_INSTALL_PREFIX}/lib)
set(includedir ${CMAKE_INSTALL_PREFIX}/include)
set(PACKAGE_VERSION 5.2.3)
set(PACKAGE_URL "http://tukaani.org/lzma/")
set(PTHREAD_CFLAGS)
# set(LIBS)
configure_file(src/liblzma/liblzma.pc.in ${CMAKE_BINARY_DIR}/liblzma.pc @ONLY)
install(FILES ${CMAKE_BINARY_DIR}/liblzma.pc DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/pkgconfig/)
