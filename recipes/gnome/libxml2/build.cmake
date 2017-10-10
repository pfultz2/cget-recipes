cmake_minimum_required(VERSION 2.8)

find_package(cget-recipe-utils)

project(libxml2)

ac_init(libxml2 2.9.4)
set(LIBXML_MAJOR_VERSION 2)
set(LIBXML_MINOR_VERSION 9)
set(LIBXML_MICRO_VERSION 4)
ac_check_headers(dlfcn.h)
ac_header_stdc()
ac_check_headers(sys/types.h sys/stat.h stdlib.h string.h memory.h strings.h 
          inttypes.h stdint.h unistd.h)
ac_check_funcs(shl_load)
ac_check_funcs(dlopen)
ac_check_headers(zlib.h)
ac_check_headers(lzma.h)
ac_header_dirent()
ac_check_headers(fcntl.h)
ac_check_headers(unistd.h)
ac_check_headers(ctype.h)
ac_check_headers(dirent.h)
ac_check_headers(errno.h)
ac_check_headers(malloc.h)
ac_check_headers(stdarg.h)
ac_check_headers(sys/stat.h)
ac_check_headers(sys/types.h)
ac_check_headers(stdint.h)
ac_check_headers(inttypes.h)
ac_check_headers(time.h)
ac_check_headers(ansidecl.h)
ac_check_headers(ieeefp.h)
ac_check_headers(nan.h)
ac_check_headers(math.h)
ac_check_headers(limits.h)
ac_check_headers(fp_class.h)
ac_check_headers(float.h)
ac_check_headers(stdlib.h)
ac_check_headers(sys/socket.h)
ac_check_headers(netinet/in.h)
ac_check_headers(arpa/inet.h)
ac_check_headers(netdb.h)
ac_check_headers(sys/time.h)
ac_check_headers(sys/select.h)
ac_check_headers(poll.h)
ac_check_headers(sys/mman.h)
ac_check_headers(sys/timeb.h)
ac_check_headers(signal.h)
ac_check_headers(arpa/nameser.h)
ac_check_headers(resolv.h)
ac_check_headers(dl.h)
ac_check_funcs(strftime)
ac_check_funcs(strdup strndup strerror)
ac_check_funcs(finite isnand fp_class class fpclass)
ac_check_funcs(strftime localtime gettimeofday ftime)
ac_check_funcs(stat _stat signal)
ac_check_funcs(rand rand_r srand time)
ac_check_funcs(isascii mmap munmap putenv)
ac_check_funcs(getaddrinfo)
ac_check_funcs(isnan)
ac_check_funcs(isinf)
ac_check_headers(pthread.h)
ac_check_headers(readline/history.h)
ac_check_headers(readline/readline.h)
ac_check_headers(iconv.h)
ac_check_headers(unicode/ucnv.h)
ac_check_funcs(printf sprintf fprintf snprintf vfprintf vsprintf vsnprintf sscanf)
ac_search_libs("" opendir dir)
ac_search_libs("" opendir x)
ac_search_libs("" gethostent nsl)
ac_search_libs("" setsockopt socket net network)
ac_search_libs("" connect inet)

ac_source_compiles("
#include <netdb.h>
int main() { (void)gethostbyname((const char *)\"\"); }
" HAVE_GETHOSTBYNAME_CONST_ARG)

if(HAVE_GETHOSTBYNAME_CONST_ARG)
    set(GETHOSTBYNAME_ARG_CAST "")
else()
    set(GETHOSTBYNAME_ARG_CAST "(char *)")
endif()
ac_source_compiles("
#include <sys/types.h>
#include <sys/socket.h>
int main() { (void)send(1,(const char *)\"\",1,1); }
" HAVE_SEND_CONST_ARG2)

if(HAVE_SEND_CONST_ARG2)
    set(SEND_ARG2_CAST "")
else()
    set(SEND_ARG2_CAST "(char *)")
endif()

ac_source_compiles("
#include <stdarg.h>
va_list ap1,ap2;
int main() { va_copy(ap1,ap2); }
" HAVE_VA_COPY)

ac_source_compiles("
#include <stdarg.h>
va_list ap1,ap2;
int main() { __va_copy(ap1,ap2); }
" HAVE___VA_COPY)

ac_source_compiles("
#include <stdarg.h>
void a(va_list * ap) {}
int main() {
    va_list ap1, ap2; 
    a(&ap1); 
    ap2 = (va_list) ap1; 
}
" VA_LIST_IS_ARRAY)

ac_source_compiles("
#include <stdlib.h>
#include <iconv.h>
extern
#ifdef __cplusplus
"C"
#endif
#if defined(__STDC__) || defined(__cplusplus)
size_t iconv (iconv_t cd, char * *inbuf, size_t *inbytesleft, char * *outbuf, size_t *outbytesleft);
#else
size_t iconv();
#endif
int main() {}
" HAVE_ICONV_MUTABLE_ARG2)

if(HAVE_ICONV_MUTABLE_ARG2)
    set(ICONV_CONST " ")
else()
    set(ICONV_CONST "const")

endif()

find_package(PkgConfig)
pkg_check_modules(Z REQUIRED zlib)
string(REPLACE ";" " " Z_LIBS "${Z_LDFLAGS}")
set(WITH_ZLIB 1)
set(HAVE_LIBZ 1)

pkg_check_modules(LZMA REQUIRED liblzma)
string(REPLACE ";" " " LZMA_LIBS "${LZMA_LDFLAGS}")
set(WITH_LZMA 1)

find_package(Threads REQUIRED)

set(THREAD_LIBS ${CMAKE_THREAD_LIBS_INIT})
set(BASE_THREAD_LIBS ${CMAKE_THREAD_LIBS_INIT})
set(WITH_THREADS 1)
set(THREAD_CFLAGS)
set(HAVE_LIBPTHREAD 1)

find_library(LIBICONV iconv)
get_filename_component(LIBICONV_DIR ${LIBICONV} DIRECTORY)
find_library(LIBCHARSET charset)
get_filename_component(LIBCHARSET_DIR ${LIBCHARSET} DIRECTORY)
set(WITH_ICONV 1)
set(ICONV_LIBS "-L${LIBICONV_DIR} -liconv -L${LIBCHARSET_DIR} -lcharset")

set(M_LIBS "-lm")

ac_config_header(config.h.in ${CMAKE_BINARY_DIR}/config.h)
ac_config_file(libxml.spec.in ${CMAKE_BINARY_DIR}/libxml2.spec)
ac_config_file(libxml-2.0.pc.in ${CMAKE_BINARY_DIR}/libxml-2.0.pc)
ac_config_file(libxml-2.0-uninstalled.pc.in ${CMAKE_BINARY_DIR}/libxml-2.0-uninstalled.pc)
ac_config_file(libxml2-config.cmake.in ${CMAKE_BINARY_DIR}/libxml2-config.cmake)
ac_config_file(xml2-config.in ${CMAKE_BINARY_DIR}/xml2-config)

include_directories(include)
include_directories(${CMAKE_BINARY_DIR})
add_definitions(-DHAVE_CONFIG_H=1)
add_definitions(-DLIBXML_THREAD_ENABLED=1)

parse_makefile_var(Makefile.am libxml2_la_SOURCES)
list_filter(libxml2_la_SOURCES EXCLUDE "^\\$")
add_library(xml2 ${libxml2_la_SOURCES})
if(THREADS_HAVE_PTHREAD_ARG)
    target_compile_options(xml2 PUBLIC "-pthread")
    target_compile_options(xml2 PUBLIC "-D_REENTRANT")
endif()
target_link_libraries(xml2 ${CMAKE_THREAD_LIBS_INIT} ${LZMA_LDFLAGS} ${Z_LDFLAGS} ${LIBICONV} ${LIBCHARSET} m)

add_executable(xmllint xmllint.c)
target_link_libraries(xmllint xml2)
add_executable(xmlcatalog xmlcatalog.c)
target_link_libraries(xmlcatalog xml2)

install(TARGETS xml2 xmllint xmlcatalog DESTINATION
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)

install(DIRECTORY include/ DESTINATION include)
install(FILES ${CMAKE_BINARY_DIR}/libxml-2.0.pc DESTINATION lib/pkgconfig)
install(FILES ${CMAKE_BINARY_DIR}/libxml2-config.cmake DESTINATION lib/cmake/xml2)
install(PROGRAMS ${CMAKE_BINARY_DIR}/xml2-config DESTINATION bin)
