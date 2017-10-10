cmake_minimum_required(VERSION 2.8)

project(flac)

find_package(cget-recipe-utils)

ac_init(flac 1.3.2)
ac_check_headers(minix/config.h)
ac_header_stdc()
ac_check_headers(sys/types.h sys/stat.h stdlib.h string.h memory.h strings.h
          inttypes.h stdint.h unistd.h)
ac_check_headers(dlfcn.h)
ac_sys_largefile()
ac_check_sizeof(off_t)
ac_check_sizeof(void*)
ac_header_stdc()
ac_c_inline()
ac_check_headers(stdint.h inttypes.h byteswap.h sys/param.h sys/ioctl.h termios.h x86intrin.h cpuid.h)
ac_c_bigendian()
set(CPU_IS_BIG_ENDIAN WORDS_BIGENDIAN)
set(CPU_IS_LITTLEBIG_ENDIAN WORDS_LITTLEENDIAN)
if(LINUX)
    set(FLAC__SYS_LINUX 1)
endif()
ac_check_types("" socklen_t)
ac_check_funcs(getopt_long)
ac_check_sizeof(void*)
ac_search_libs(HAVE_LROUND lround m)
ac_includes_default_list()

ac_check_headers(x86intrin.h)
if(HAVE_X86INTRIN_H)
    set(FLAC__HAS_X86INTRIN 1)
endif()

# TODO: Check this
set(FLAC__CPU_X86_64 1)

find_package(PkgConfig)
pkg_check_modules(OGG REQUIRED ogg)
set(FLAC__HAS_OGG 1)
set(OGG_PACKAGE ogg)

ac_config_header(config.h.in ${CMAKE_BINARY_DIR}/config.h)
ac_config_file(src/libFLAC/flac.pc.in flac.pc @ONLY)
ac_config_file(src/libFLAC++/flac++.pc.in flac++.pc @ONLY)

add_definitions(-DHAVE_CONFIG_H=1)

include_directories(include)
include_directories(${CMAKE_BINARY_DIR})


include_directories(src/libFLAC/include)
set(libFLAC_SRCS)
parse_makefile_var(src/libFLAC/Makefile.am libFLAC_sources)
list_filter(libFLAC_sources EXCLUDE "^\\$")
# list(FILTER libFLAC_sources EXCLUDE REGEX "^\\$")
append_prefix(src/libFLAC/ libFLAC_SRCS ${libFLAC_sources})

parse_makefile_var(src/libFLAC/Makefile.am extra_ogg_sources)
append_prefix(src/libFLAC/ libFLAC_SRCS ${extra_ogg_sources})

if(WIN32)
    parse_makefile_var(src/libFLAC/Makefile.am windows_unicode_compat)
    append_prefix(src/libFLAC/ libFLAC_SRCS ${windows_unicode_compat})
endif()

add_library(FLAC ${libFLAC_SRCS})
target_link_libraries(FLAC ${OGG_LDFLAGS})
target_compile_options(FLAC PUBLIC ${OGG_CFLAGS})

parse_makefile_var(src/libFLAC++/Makefile.am libFLAC___la_SOURCES)
set(libFLACPP_SRCS)
append_prefix(src/libFLAC++/ libFLACPP_SRCS ${libFLAC___la_SOURCES})
add_library(FLAC++ ${libFLACPP_SRCS})
target_link_libraries(FLAC++ FLAC)

install(TARGETS FLAC FLAC++ DESTINATION lib)
install(DIRECTORY include/ DESTINATION include)


# TODO: Build executable
# parse_makefile_var(src/flac/Makefile.am flac_SOURCES)
