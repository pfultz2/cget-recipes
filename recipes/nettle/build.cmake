cmake_minimum_required(VERSION 2.8)

find_package(cget-recipe-utils)

project(nettle)
set(NETTLE_USE_MINI_GMP 1)

# check_function_exists(__attribute HAVE_GCC_ATTRIBUTE)
# HAVE_LINK_IFUNC

ac_init("nettle" 3.3)
ac_c_inline()
ac_type_size_t()
ac_check_type(size_t)
ac_header_stdc()
ac_check_headers(sys/types.h sys/stat.h stdlib.h string.h memory.h strings.h
          inttypes.h stdint.h unistd.h)
ac_header_time()
ac_check_sizeof(long)
ac_check_sizeof(size_t)
ac_check_headers(openssl/blowfish.h openssl/des.h openssl/cast.h openssl/aes.h openssl/ecdsa.h)
ac_check_headers(valgrind/memcheck.h)
ac_check_headers(alloca.h)
ac_check_funcs(alloca)
ac_check_headers(dlfcn.h)
ac_check_headers(malloc.h)
ac_check_funcs(strerror)
ac_check_funcs(secure_getenv getline)
ac_c_bigendian()
ac_check_type(uint64_t)
ac_check_type(uint32_t)
ac_check_type(u_int32_t)
ac_check_type(u_int64_t)
ac_check_sizeof(char)
ac_check_sizeof(short)
ac_check_sizeof(int)
ac_check_sizeof(long)
ac_check_sizeof(void*)
ac_check_type(int_least32_t)
ac_check_type(int_fast32_t)
ac_check_type(intmax_t)

ac_search_libs(HAVE_CLOCK_GETTIME clock_gettime rt)
ac_check_lib(HAVE_LIBDL dl dlopen)
ac_check_lib("" gmp __gmpz_powm_sec)

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
