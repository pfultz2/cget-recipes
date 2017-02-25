# Copyright (C) 2007-2013 LuaDist.
# Created by Peter Drahoš, Peter Kapec
# Redistribution and use of this file is allowed according to the terms of the MIT license.
# For details see the COPYRIGHT file distributed with LuaDist.
# Please note that the package source code is licensed under its own license.

project ( libev C )
cmake_minimum_required ( VERSION 2.8 )
## INSTALL DEFAULTS (Relative to CMAKE_INSTALL_PREFIX)
# Primary paths
set ( INSTALL_BIN bin CACHE PATH "Where to install binaries to." )
set ( INSTALL_LIB lib CACHE PATH "Where to install libraries to." )
set ( INSTALL_INC include CACHE PATH "Where to install headers to." )
set ( INSTALL_ETC etc CACHE PATH "Where to store configuration files" )
set ( INSTALL_SHARE share CACHE PATH "Directory for shared data." )

# Secondary paths
option ( INSTALL_VERSION
      "Install runtime libraries and executables with version information." OFF)
set ( INSTALL_DATA ${INSTALL_SHARE}/${DIST_NAME} CACHE PATH
      "Directory the package can store documentation, tests or other data in.")  
set ( INSTALL_DOC  ${INSTALL_DATA}/doc CACHE PATH
      "Recommended directory to install documentation into.")
set ( INSTALL_EXAMPLE ${INSTALL_DATA}/example CACHE PATH
      "Recommended directory to install examples into.")
set ( INSTALL_TEST ${INSTALL_DATA}/test CACHE PATH
      "Recommended directory to install tests into.")
set ( INSTALL_FOO  ${INSTALL_DATA}/etc CACHE PATH
      "Where to install additional files")

# In MSVC, prevent warnings that can occur when using standard libraries.
if ( MSVC )
  add_definitions ( -D_CRT_SECURE_NO_WARNINGS )
endif ()


# Platform checks
include ( CheckFunctionExists )
include ( CheckIncludeFiles )

check_include_files ( dlfcn.h HAVE_DLFCN_H )
check_include_files ( inttypes.h HAVE_INTTYPES_H )
check_include_files ( memory.h HAVE_MEMORY_H )
check_include_files ( poll.h HAVE_POLL_H )
check_include_files ( port.h HAVE_PORT_H )
check_include_files ( stdint.h HAVE_STDINT_H )
check_include_files ( stdlib.h HAVE_STDLIB_H )
check_include_files ( strings.h HAVE_STRINGS_H )
check_include_files ( string.h HAVE_STRING_H )
check_include_files ( "sys/epoll.h" HAVE_SYS_EPOLL_H )
check_include_files ( "sys/eventfd.h" HAVE_SYS_EVENTFD_H )
check_include_files ( "sys/event.h" HAVE_SYS_EVENT_H )
check_include_files ( "sys/inotify.h" HAVE_SYS_INOTIFY_H )
check_include_files ( "sys/select.h" HAVE_SYS_SELECT_H )
check_include_files ( "sys/signalfd.h" HAVE_SYS_SIGNALFD_H )
check_include_files ( "sys/stat.h" HAVE_SYS_STAT_H )
check_include_files ( "sys/types.h" HAVE_SYS_TYPES_H )
check_include_files ( unistd.h HAVE_UNISTD_H )

check_function_exists ( clock_gettime HAVE_CLOCK_GETTIME )
check_function_exists ( epoll_ctl HAVE_EPOLL_CTL )
check_function_exists ( eventfd HAVE_EVENTFD )
check_function_exists ( floor HAVE_FLOOR )
check_function_exists ( inotify_init HAVE_INOTIFY_INIT )
check_function_exists ( kqueue HAVE_KQUEUE )
check_function_exists ( nanosleep HAVE_NANOSLEEP )
check_function_exists ( poll HAVE_POLL )
check_function_exists ( port_create HAVE_PORT_CREATE )
check_function_exists ( select HAVE_SELECT )
check_function_exists ( signalfd HAVE_SIGNALFD )

find_library ( HAVE_LIBRT rt )

# Tweaks
set ( HAVE_CLOCK_SYSCALL ${HAVE_CLOCK_GETTIME} )

if(MSVC)
  file(READ ${CMAKE_CURRENT_SOURCE_DIR}/event.c event_c_file)
  file(WRITE ${CMAKE_CURRENT_SOURCE_DIR}/event.c "
#include <winsock2.h>
${event_c_file}")
endif()

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/config.h.in "
/* config.h.in.  Generated from configure.ac by autoheader.  */

/* Define to 1 if you have the `clock_gettime' function. */
#cmakedefine HAVE_CLOCK_GETTIME 1

/* Define to 1 to use the syscall interface for clock_gettime */
#cmakedefine HAVE_CLOCK_SYSCALL 1

/* Define to 1 if you have the <dlfcn.h> header file. */
#cmakedefine HAVE_DLFCN_H 1

/* Define to 1 if you have the `epoll_ctl' function. */
#cmakedefine HAVE_EPOLL_CTL 1

/* Define to 1 if you have the `eventfd' function. */
#cmakedefine HAVE_EVENTFD 1

/* Define to 1 if the floor function is available */
#cmakedefine HAVE_FLOOR 1

/* Define to 1 if you have the `inotify_init' function. */
#cmakedefine HAVE_INOTIFY_INIT 1

/* Define to 1 if you have the <inttypes.h> header file. */
#cmakedefine HAVE_INTTYPES_H 1

/* Define to 1 if you have the `kqueue' function. */
#cmakedefine HAVE_KQUEUE 1

/* Define to 1 if you have the `rt' library (-lrt). */
#cmakedefine HAVE_LIBRT 1

/* Define to 1 if you have the <memory.h> header file. */
#cmakedefine HAVE_MEMORY_H 1

/* Define to 1 if you have the `nanosleep' function. */
#cmakedefine HAVE_NANOSLEEP 1

/* Define to 1 if you have the `poll' function. */
#cmakedefine HAVE_POLL 1

/* Define to 1 if you have the <poll.h> header file. */
#cmakedefine HAVE_POLL_H 1

/* Define to 1 if you have the `port_create' function. */
#cmakedefine HAVE_PORT_CREATE 1

/* Define to 1 if you have the <port.h> header file. */
#cmakedefine HAVE_PORT_H 1

/* Define to 1 if you have the `select' function. */
#cmakedefine HAVE_SELECT 1

/* Define to 1 if you have the `signalfd' function. */
#cmakedefine HAVE_SIGNALFD 1

/* Define to 1 if you have the <stdint.h> header file. */
#cmakedefine HAVE_STDINT_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#cmakedefine HAVE_STDLIB_H 1

/* Define to 1 if you have the <strings.h> header file. */
#cmakedefine HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#cmakedefine HAVE_STRING_H 1

/* Define to 1 if you have the <sys/epoll.h> header file. */
#cmakedefine HAVE_SYS_EPOLL_H 1

/* Define to 1 if you have the <sys/eventfd.h> header file. */
#cmakedefine HAVE_SYS_EVENTFD_H 1

/* Define to 1 if you have the <sys/event.h> header file. */
#cmakedefine HAVE_SYS_EVENT_H 1

/* Define to 1 if you have the <sys/inotify.h> header file. */
#cmakedefine HAVE_SYS_INOTIFY_H 1

/* Define to 1 if you have the <sys/select.h> header file. */
#cmakedefine HAVE_SYS_SELECT_H 1

/* Define to 1 if you have the <sys/signalfd.h> header file. */
#cmakedefine HAVE_SYS_SIGNALFD_H 1

/* Define to 1 if you have the <sys/stat.h> header file. */
#cmakedefine HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#cmakedefine HAVE_SYS_TYPES_H 1

/* Define to 1 if you have the <unistd.h> header file. */
#cmakedefine HAVE_UNISTD_H 1

/* Define to the sub-directory in which libtool stores uninstalled libraries.
   */
#define LT_OBJDIR \".libs/\"

/* Name of package */
#define PACKAGE \"libev\"

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT \"\"

/* Define to the full name of this package. */
#define PACKAGE_NAME \"\"

/* Define to the full name and version of this package. */
#define PACKAGE_STRING \"\"

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME \"\"

/* Define to the home page for this package. */
#define PACKAGE_URL \"\"

/* Define to the version of this package. */
#define PACKAGE_VERSION \"\"

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* Version number of package */
#cmakedefine VERSION \"@DIST_VERSION@\"

")
configure_file ( ${CMAKE_CURRENT_BINARY_DIR}/config.h.in ${CMAKE_CURRENT_BINARY_DIR}/config.h )
include_directories( ${CMAKE_CURRENT_BINARY_DIR} )

set ( EV_SRC 
  ev.c
  event.c
)

if (WIN32) 
  list ( APPEND EV_LIBS Ws2_32 )
endif ()

add_library ( ev ${EV_SRC} )
target_link_libraries ( ev ${EV_LIBS} )

install(TARGETS ev RUNTIME DESTINATION ${INSTALL_BIN} LIBRARY DESTINATION ${INSTALL_LIB} ARCHIVE DESTINATION ${INSTALL_LIB})
install(FILES ev.h ev++.h event.h DESTINATION ${INSTALL_INC})

