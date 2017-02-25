# Copyright (C) 2007-2012 LuaDist.
# Created by Peter Kapec, David Manura
# Redistribution and use of this file is allowed according to the terms of the MIT license.
# For details see the COPYRIGHT file distributed with LuaDist.
# Please note that the package source code is licensed under its own license.

project ( libjpeg C )
cmake_minimum_required ( VERSION 2.8 )
# Where to install module parts:
set(INSTALL_BIN bin CACHE PATH "Where to install binaries to.")
set(INSTALL_LIB lib CACHE PATH "Where to install libraries to.")
set(INSTALL_INC include CACHE PATH "Where to install headers to.")
set(INSTALL_ETC etc CACHE PATH "Where to store configuration files")
set(INSTALL_DATA share/${PROJECT_NAME} CACHE PATH "Directory the package can store documentation, tests or other data in.")
set(INSTALL_DOC ${INSTALL_DATA}/doc CACHE PATH "Recommended directory to install documentation into.")
set(INSTALL_EXAMPLE ${INSTALL_DATA}/example CACHE PATH "Recommended directory to install examples into.")
set(INSTALL_TEST ${INSTALL_DATA}/test CACHE PATH "Recommended directory to install tests into.")
set(INSTALL_FOO ${INSTALL_DATA}/etc CACHE PATH "Where to install additional files")


OPTION(BUILD_STATIC OFF)
OPTION(BUILD_EXECUTABLES ON)
OPTION(BUILD_TESTS ON)

include ( CheckIncludeFile )
check_include_file ( stddef.h HAVE_STDDEF_H )
check_include_file ( stdlib.h HAVE_STDLIB_H )
if ( WIN32 AND NOT CYGWIN )
  #improve? see jconfig.*
  set ( TWO_FILE_COMMANDLINE true )
  # jconfig.h
endif ( )
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/jconfig.h.in "
/* based on jconfig.txt */

/*
 * jconfig.txt
 *
 * Copyright (C) 1991-1994, Thomas G. Lane.
 * This file is part of the Independent JPEG Group's software.
 * For conditions of distribution and use, see the accompanying README file.
 *
 * This file documents the configuration options that are required to
 * customize the JPEG software for a particular system.
 *
 * The actual configuration options for a particular installation are stored
 * in jconfig.h.  On many machines, jconfig.h can be generated automatically
 * or copied from one of the canned jconfig files that we supply.  But if
 * you need to generate a jconfig.h file by hand, this file tells you how.
 */


/*
 * These symbols indicate the properties of your machine or compiler.
 * #define the symbol if yes, #undef it if no.
 */

/* Does your compiler support function prototypes?
 * (If not, you also need to use ansi2knr, see install.txt)
 */
#define HAVE_PROTOTYPES

/* Does your compiler support the declaration unsigned char ?
 * How about unsigned short ?
 */
#define HAVE_UNSIGNED_CHAR
#define HAVE_UNSIGNED_SHORT

/* Define void as char if your compiler doesn't know about type void.
 * NOTE: be sure to define void such that void * represents the most general
 * pointer type, e.g., that returned by malloc().
 */
/* #define void char */

/* Define const as empty if your compiler doesn't know the const keyword.
 */
/* #define const */

/* Define this if an ordinary char type is unsigned.
 * If you're not sure, leaving it undefined will work at some cost in speed.
 * If you defined HAVE_UNSIGNED_CHAR then the speed difference is minimal.
 */
#undef CHAR_IS_UNSIGNED

/* Define this if your system has an ANSI-conforming <stddef.h> file.
 */
#cmakedefine HAVE_STDDEF_H

/* Define this if your system has an ANSI-conforming <stdlib.h> file.
 */
#cmakedefine HAVE_STDLIB_H

/* Define this if your system does not have an ANSI/SysV <string.h>,
 * but does have a BSD-style <strings.h>.
 */
#undef NEED_BSD_STRINGS

/* Define this if your system does not provide typedef size_t in any of the
 * ANSI-standard places (stddef.h, stdlib.h, or stdio.h), but places it in
 * <sys/types.h> instead.
 */
#undef NEED_SYS_TYPES_H

/* For 80x86 machines, you need to define NEED_FAR_POINTERS,
 * unless you are using a large-data memory model or 80386 flat-memory mode.
 * On less brain-damaged CPUs this symbol must not be defined.
 * (Defining this symbol causes large data structures to be referenced through
 * far pointers and to be allocated with a special version of malloc.)
 */
#undef NEED_FAR_POINTERS

/* Define this if your linker needs global names to be unique in less
 * than the first 15 characters.
 */
#undef NEED_SHORT_EXTERNAL_NAMES

/* Although a real ANSI C compiler can deal perfectly well with pointers to
 * unspecified structures (see "incomplete types" in the spec), a few pre-ANSI
 * and pseudo-ANSI compilers get confused.  To keep one of these bozos happy,
 * define INCOMPLETE_TYPES_BROKEN.  This is not recommended unless you
 * actually get missing structure definition warnings or errors while
 * compiling the JPEG code.
 */
#undef INCOMPLETE_TYPES_BROKEN

/* from jconfig.vc */
#ifdef _MSC_VER
  /* Define boolean as unsigned char, not int, per Windows custom */
  #ifndef __RPCNDR_H__		/* don't conflict if rpcndr.h already read */
  typedef unsigned char boolean;
  #define TRUE 1
  #define FALSE 0
  #endif
  #define HAVE_BOOLEAN		/* prevent jmorecfg.h from redefining it */
#endif

/*
 * The following options affect code selection within the JPEG library,
 * but they don't need to be visible to applications using the library.
 * To minimize application namespace pollution, the symbols won't be
 * defined unless JPEG_INTERNALS has been defined.
 */

#ifdef JPEG_INTERNALS

/* Define this if your compiler implements >> on signed values as a logical
 * (unsigned) shift; leave it undefined if >> is a signed (arithmetic) shift,
 * which is the normal and rational definition.
 */
#undef RIGHT_SHIFT_IS_UNSIGNED


#endif /* JPEG_INTERNALS */


/*
 * The remaining options do not affect the JPEG library proper,
 * but only the sample applications cjpeg/djpeg (see cjpeg.c, djpeg.c).
 * Other applications can ignore these.
 */

#ifdef JPEG_CJPEG_DJPEG

/* These defines indicate which image (non-JPEG) file formats are allowed. */

#define BMP_SUPPORTED		/* BMP image file format */
#define GIF_SUPPORTED		/* GIF image file format */
#define PPM_SUPPORTED		/* PBMPLUS PPM/PGM image file format */
#undef RLE_SUPPORTED		/* Utah RLE image file format */
#define TARGA_SUPPORTED		/* Targa image file format */

/* Define this if you want to name both input and output files on the command
 * line, rather than using stdout and optionally stdin.  You MUST do this if
 * your system can't cope with binary I/O to stdin/stdout.  See comments at
 * head of cjpeg.c or djpeg.c.
 */
#cmakedefine TWO_FILE_COMMANDLINE

/* Define this if your system needs explicit cleanup of temporary files.
 * This is crucial under MS-DOS, where the temporary files may be areas
 * of extended memory; on most other systems it's not as important.
 */
#undef NEED_SIGNAL_CATCHER

/* By default, we open image files with fopen(...,rb) or fopen(...,wb).
 * This is necessary on systems that distinguish text files from binary files,
 * and is harmless on most systems that don't.  If you have one of the rare
 * systems that complains about the b spec, define this symbol.
 */
#undef DONT_USE_B_MODE

/* Define this if you want percent-done progress reports from cjpeg/djpeg.
 */
#undef PROGRESS_REPORT


#endif /* JPEG_CJPEG_DJPEG */

")
configure_file ( ${CMAKE_CURRENT_BINARY_DIR}/jconfig.h.in ${CMAKE_CURRENT_BINARY_DIR}/jconfig.h )

include_directories ( ${CMAKE_CURRENT_BINARY_DIR} )
# jconfig.h

set ( HEADERS jerror.h jmorecfg.h jpeglib.h ${CMAKE_CURRENT_BINARY_DIR}/jconfig.h )

set ( SRC jmemnobs.c jaricom.c jcapimin.c jcapistd.c jcarith.c jccoefct.c jccolor.c 
  jcdctmgr.c jchuff.c jcinit.c jcmainct.c jcmarker.c jcmaster.c jcomapi.c jcparam.c 
  jcprepct.c jcsample.c jctrans.c jdapimin.c jdapistd.c jdarith.c jdatadst.c jdatasrc.c 
  jdcoefct.c jdcolor.c jddctmgr.c jdhuff.c jdinput.c jdmainct.c jdmarker.c jdmaster.c 
  jdmerge.c jdpostct.c jdsample.c jdtrans.c jerror.c jfdctflt.c jfdctfst.c jfdctint.c 
  jidctflt.c jidctfst.c jidctint.c jquant1.c jquant2.c jutils.c jmemmgr.c cderror.h 
  cdjpeg.h jdct.h jinclude.h jmemsys.h jpegint.h jversion.h transupp.h )

if ( BUILD_STATIC )
  add_library ( jpeg STATIC ${SRC} ${HEADERS} )
else ()
  add_library ( jpeg ${SRC} ${HEADERS} )
endif()

if ( BUILD_EXECUTABLES )
  add_executable ( cjpeg cdjpeg.c cjpeg.c rdbmp.c rdgif.c rdppm.c rdrle.c rdtarga.c 
    rdswitch.c )
  add_executable ( djpeg cdjpeg.c djpeg.c wrbmp.c wrgif.c wrppm.c wrrle.c wrtarga.c 
    rdcolmap.c )
  add_executable ( jpegtran jpegtran.c cdjpeg.c rdswitch.c transupp.c )
  add_executable ( rdjpgcom rdjpgcom.c )
  add_executable ( wrjpgcom wrjpgcom.c )
  target_link_libraries ( cjpeg jpeg )
  target_link_libraries ( djpeg jpeg )
  target_link_libraries ( jpegtran jpeg )
endif ()

if ( BUILD_EXECUTABLES )
  install (TARGETS cjpeg djpeg jpegtran rdjpgcom wrjpgcom DESTINATION ${INSTALL_BIN})
endif ()

install (TARGETS jpeg DESTINATION ${INSTALL_LIB})
install (FILES ${HEADERS} DESTINATION INSTALL_INC)
install (FILES README install.txt usage.txt wizard.txt example.c libjpeg.txt structure.txt 
  coderules.txt filelist.txt change.log DESTINATION ${INSTALL_DOC})

if ( BUILD_TESTS )
  # tests
  enable_testing ( )
  macro ( mytest name target args input output )
  get_target_property ( _cmdpath ${target} LOCATION )
  add_test ( ${name} ${CMAKE_COMMAND} "-DCOMMAND=${_cmdpath} ${args}" "-DINPUT=${input}" 
    "-DOUTPUT=${output}" -P ${CMAKE_CURRENT_SOURCE_DIR}/jpeg_test.cmake )
  endmacro ( )
  set ( _src "${CMAKE_CURRENT_SOURCE_DIR}" )
  mytest ( t1 djpeg "-dct int -ppm -outfile testout.ppm ${_src}/testorig.jpg" "${_src}/testimg.ppm" 
    testout.ppm )
  mytest ( t2 djpeg "-dct int -bmp -colors 256 -outfile testout.bmp ${_src}/testorig.jpg" 
    ${_src}/testimg.bmp testout.bmp )
  mytest ( t3 cjpeg "-dct int -outfile testout.jpg ${_src}/testimg.ppm" ${_src}/testimg.jpg 
    testout.jpg )
  mytest ( t4 djpeg "-dct int -ppm -outfile testoutp.ppm ${_src}/testprog.jpg" ${_src}/testimg.ppm 
    testoutp.ppm )
  mytest ( t5 cjpeg "-dct int -progressive -opt -outfile testoutp.jpg ${_src}/testimg.ppm" 
    ${_src}/testimgp.jpg testoutp.jpg )
  mytest ( t6 jpegtran "-outfile testoutt.jpg ${_src}/testprog.jpg" ${_src}/testorig.jpg 
    testoutt.jpg )
endif ()
