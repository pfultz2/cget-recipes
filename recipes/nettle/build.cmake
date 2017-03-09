cmake_minimum_required(VERSION 2.8)

find_package(cget-recipe-utils)

project(nettle)
set(PACKAGE_VERSION 3.3)
set(MAJOR_VERSION 3)
set(MINOR_VERSION 3)
set(NETTLE_USE_MINI_GMP 1)

include ( CheckFunctionExists )
include ( CheckIncludeFiles )
include ( CheckTypeSize )

# check_function_exists(__attribute HAVE_GCC_ATTRIBUTE)
# HAVE_LIBDL
# HAVE_LIBGMP
# HAVE_LINK_IFUNC

check_include_files(alloca.h HAVE_ALLOCA_H)
check_include_files(dlfcn.h HAVE_DLFCN_H)
check_include_files(inttypes.h HAVE_INTTYPES_H)
check_include_files(malloc.h HAVE_MALLOC_H)
check_include_files(memory.h HAVE_MEMORY_H)
check_include_files(openssl/aes.h HAVE_OPENSSL_AES_H)
check_include_files(openssl/blowfish.h HAVE_OPENSSL_BLOWFISH_H)
check_include_files(openssl/cast.h HAVE_OPENSSL_CAST_H)
check_include_files(openssl/des.h HAVE_OPENSSL_DES_H)
check_include_files(openssl/ecdsa.h HAVE_OPENSSL_ECDSA_H)
check_include_files(stdint.h HAVE_STDINT_H)
check_include_files(stdlib.h HAVE_STDLIB_H)
check_include_files(strings.h HAVE_STRINGS_H)
check_include_files(string.h HAVE_STRING_H)
check_include_files(sys/stat.h HAVE_SYS_STAT_H)
check_include_files(sys/types.h HAVE_SYS_TYPES_H)
check_include_files(unistd.h HAVE_UNISTD_H)
check_include_files(valgrind/memcheck.h HAVE_VALGRIND_MEMCHECK_H)

check_function_exists(alloca HAVE_ALLOCA)
check_function_exists(fcntl HAVE_FCNTL_LOCKING)
check_function_exists(clock_gettime HAVE_CLOCK_GETTIME)
check_function_exists(getline HAVE_GETLINE)
check_function_exists(secure_getenv HAVE_SECURE_GETENV)
check_function_exists(strerror HAVE_STRERROR)

check_type_size("char" SIZEOF_CHAR)
check_type_size("int" SIZEOF_INT)
check_type_size("long" SIZEOF_LONG)
check_type_size("short" SIZEOF_SHORT)
check_type_size("size_t" SIZEOF_SIZE_T)
check_type_size("void*" SIZEOF_VOIDP)

set(STDC_HEADERS On)
set(WITH_HOGWEED On)
set(WITH_OPENSSL On)

set(CHAR_BITS 8) # Always assume 8 bits for char
set(GMP_NUMB_BITS "${SIZEOF_LONG} * ${CHAR_BITS}")

ac_config_header(config.h.in ${CMAKE_BINARY_DIR}/config.h)
configure_file(version.h.in ${CMAKE_BINARY_DIR}/version.h @ONLY)

file(WRITE ${CMAKE_BINARY_DIR}/nettle-stdint.h "
#include <stdint.h>
")

add_definitions(-DUNUSED=)
add_definitions(-DHAVE_CONFIG_H=1)
include_directories(.)
include_directories(${CMAKE_BINARY_DIR})
parse_makefile_var(Makefile.in getopt_SOURCES)
parse_makefile_var(Makefile.in internal_SOURCES)
parse_makefile_var(Makefile.in nettle_SOURCES)
parse_makefile_var(Makefile.in hogweed_SOURCES)
parse_makefile_var(Makefile.in HEADERS)

add_library(nettle ${nettle_SOURCES})
# add_library(hogweed ${hogweed_SOURCES})

install(TARGETS 
    nettle 
    # hogweed 
DESTINATION
    RUNTIME DESTINATION bin
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
)

install(FILES 
    ${HEADERS}
    mini-gmp.h
    ${CMAKE_BINARY_DIR}/config.h 
    ${CMAKE_BINARY_DIR}/version.h 
    ${CMAKE_BINARY_DIR}/nettle-stdint.h 
    DESTINATION include/nettle)

set(prefix ${CMAKE_INSTALL_PREFIX})
set(exec_prefix ${CMAKE_INSTALL_PREFIX})
set(libdir ${CMAKE_INSTALL_PREFIX}/lib)
set(includedir ${CMAKE_INSTALL_PREFIX}/include)
configure_file(nettle.pc.in ${CMAKE_BINARY_DIR}/nettle.pc @ONLY)
install(FILES ${CMAKE_BINARY_DIR}/nettle.pc DESTINATION lib/pkgconfig)
