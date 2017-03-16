cmake_minimum_required(VERSION 2.8)

project(libiconv C)

find_package(cget-recipe-utils)

ac_init(libiconv 1.15)
ac_check_headers(minix/config.h)
ac_header_stdc()
ac_check_headers(sys/types.h sys/stat.h stdlib.h string.h memory.h strings.h
          inttypes.h stdint.h unistd.h)
ac_check_headers(mach-o/dyld.h)
ac_check_funcs(_NSGetExecutablePath)
ac_check_headers(dlfcn.h)
ac_check_funcs(getc_unlocked mbrtowc wcrtomb mbsinit setlocale)
ac_replace_funcs("" memmove)
ac_check_funcs(memmove)
ac_check_headers(wchar.h)
ac_type_size_t()
ac_check_type(size_t "")
ac_check_headers(stdlib.h string.h)
ac_check_funcs(canonicalize_file_name getcwd readlink)
ac_check_funcs(realpath)
ac_check_headers(sys/param.h)
ac_libobj(canonicalize-lgpl)
ac_check_funcs(readlinkat)
ac_libobj(error)
ac_check_decl(strerror_r "")
ac_check_funcs(strerror_r)
ac_c_inline()
ac_check_funcs(lstat)
ac_libobj(lstat)
ac_check_headers(stdlib.h)
ac_check_headers(stdlib.h)
ac_check_funcs(memmove)
ac_libobj(memmove)
ac_check_headers(sys/param.h)
ac_check_decls("#include <errno.h>" program_invocation_name)
ac_check_decl(program_invocation_name "#include <errno.h>")
ac_check_decls("#include <errno.h>" program_invocation_short_name)
ac_check_decl(program_invocation_short_name "#include <errno.h>")
ac_libobj(read)
ac_check_funcs(readlink)
ac_libobj(readlink)
ac_libobj(progreloc)
ac_check_funcs(readlink)
ac_check_funcs(canonicalize_file_name getcwd readlink)
ac_check_headers(sys/param.h)
ac_check_decl(setenv "")
ac_check_funcs(setenv)
ac_check_headers(unistd.h)
ac_check_headers(search.h)
ac_check_funcs(tsearch)
ac_check_types("
      #include <signal.h>
      /* Mingw defines sigset_t not in <signal.h>, but in <sys/types.h>.  */
      #include <sys/types.h>
    " sigset_t)
ac_check_type(volatile sig_atomic_t "
#include <signal.h>
    ")
ac_check_type(sighandler_t "
#include <signal.h>
    ")
ac_libobj(sigprocmask)
ac_check_funcs(lstat)
ac_libobj(stat)
ac_check_types("" _Bool)
ac_check_headers(wchar.h)
ac_check_headers(stdint.h)
ac_check_headers(sys/inttypes.h sys/bitypes.h)
ac_libobj(stdio-write)
ac_libobj(strerror)
ac_libobj(strerror-override)
ac_check_headers(winsock2.h)
ac_check_headers(sys/stat.h)
ac_check_type(nlink_t "#include <sys/types.h>
     #include <sys/stat.h>")
ac_check_headers(sys/time.h)
ac_check_headers(unistd.h)
ac_check_decls("" clearerr_unlocked)
ac_check_decl(clearerr_unlocked "")
ac_check_decls("" feof_unlocked)
ac_check_decl(feof_unlocked "")
ac_check_decls("" ferror_unlocked)
ac_check_decl(ferror_unlocked "")
ac_check_decls("" fflush_unlocked)
ac_check_decl(fflush_unlocked "")
ac_check_decls("" fgets_unlocked)
ac_check_decl(fgets_unlocked "")
ac_check_decls("" fputc_unlocked)
ac_check_decl(fputc_unlocked "")
ac_check_decls("" fputs_unlocked)
ac_check_decl(fputs_unlocked "")
ac_check_decls("" fread_unlocked)
ac_check_decl(fread_unlocked "")
ac_check_decls("" fwrite_unlocked)
ac_check_decl(fwrite_unlocked "")
ac_check_decls("" getc_unlocked)
ac_check_decl(getc_unlocked "")
ac_check_decls("" getchar_unlocked)
ac_check_decl(getchar_unlocked "")
ac_check_decls("" putc_unlocked)
ac_check_decl(putc_unlocked "")
ac_check_decls("" putchar_unlocked)
ac_check_decl(putchar_unlocked "")

ac_includes_default_list()
ac_source_runs("
#include <limits.h>
#ifndef LLONG_MAX
# define HALF \
(1LL << (sizeof (long long int) * CHAR_BIT - 2))
# define LLONG_MAX (HALF - 1 + HALF)
#endif
int main() { long long int n = 1;
int i;
for (i = 0; ; i++)
{
long long int m = n << i;
if (m >> i != n)
return 1;
if (LLONG_MAX / 2 < m)
break;
}
return 0; }
" HAVE_LONG_LONG_INT)


ac_source_compiles("
#include <sys/socket.h>
int main() { int a[] = { SHUT_RD, SHUT_WR, SHUT_RDWR }; }
" _POSIX_PII_SOCKET)

ac_check_decls("
#include <iconv.h>
#include <string.h>" iconv)

ac_source_runs("
#include <sys/stat.h>
int main() { struct stat st; return stat (".", &st) != stat ("./", &st); }
" gl_cv_func_stat_dir_slash)
ac_source_runs("
#include <sys/stat.h>
int main() { int result = 0;
struct stat st;
if (!stat ("conftest.tmp/", &st))
result |= 1;
#if HAVE_LSTAT
if (!stat ("conftest.lnk/", &st))
result |= 2;
#endif
return result;
}
" gl_cv_func_stat_file_slash)

if(NOT gl_cv_func_stat_dir_slash AND NOT gl_cv_func_stat_file_slash)
    set(REPLACE_FUNC_STAT_FILE 1)
endif()

ac_source_runs("
${AC_INCLUDES_DEFAULT}
int main() { struct stat sbuf;
/* Linux will dereference the symlink and fail, as required by
POSIX.  That is better in the sense that it means we will not
have to compile and use the lstat wrapper.  */
return lstat ("conftest.sym/", &sbuf) == 0;
}
" LSTAT_FOLLOWS_SLASHED_SYMLINK)

ac_source_runs("
#include <string.h>
#include <errno.h>
int main() { int result = 0;
char *str;
errno = 0;
str = strerror (0);
if (!*str) result |= 1;
if (errno) result |= 2;
if (strstr (str, "nknown") || strstr (str, "ndefined"))
result |= 4;
return result; }
" REPLACE_STRERROR_0)

ac_check_types("
#include <stddef.h>
" wchar_t)

ac_source_compiles("
#include <wchar.h>
wchar_t w;
int main() {}
" gl_cv_header_wchar_h_standalone)

if(gl_cv_header_wchar_h_standalone)
    set(BROKEN_WCHAR_H 0)
else()
    set(BROKEN_WCHAR_H 1)
endif()

ac_source_compiles("
#undef _BSD
#define _BSD 1 /* unhide unsetenv declaration in OSF/1 5.1 <stdlib.h> */
#include <stdlib.h>
extern
#ifdef __cplusplus
\"C\"
#endif
#if defined(__STDC__) || defined(__cplusplus)
int unsetenv (const char *name);
#else
int unsetenv();
#endif
int main {}
" VOID_UNSETENV)

ac_source_compiles("
${AC_INCLUDES_DEFAULT}
/* Tru64 with Desktop Toolkit C has a bug: <stdio.h> must be included before
<wchar.h>.
BSD/OS 4.0.1 has a bug: <stddef.h>, <stdio.h> and <time.h> must be
included before <wchar.h>.  */
#include <stddef.h>
#include <stdio.h>
#include <time.h>
#include <wchar.h>
int main() { mbstate_t x; return sizeof x; }
" USE_MBSTATE_T)

ac_source_compiles("
#include <unistd.h>
/* Cause compilation failure if original declaration has wrong type.  */
ssize_t readlink (const char *, char *, size_t);
" READLINK_TRAILING_SLASH_BUG)

ac_source_compiles("
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#ifndef O_NOATIME
#define O_NOATIME 0
#endif
#ifndef O_NOFOLLOW
#define O_NOFOLLOW 0
#endif
static int const constants[] =
{
O_CREAT, O_EXCL, O_NOCTTY, O_TRUNC, O_APPEND,
O_NONBLOCK, O_SYNC, O_ACCMODE, O_RDONLY, O_RDWR, O_WRONLY
};
int main() { 
int status = !constants;
{
static char const sym[] = \"conftest.sym\";
if (symlink (\".\", sym) != 0
|| close (open (sym, O_RDONLY | O_NOFOLLOW)) == 0)
status |= 32;
unlink (sym);
}
{
static char const file[] = \"confdefs.h\";
int fd = open (file, O_RDONLY | O_NOATIME);
char c;
struct stat st0, st1;
if (fd < 0
|| fstat (fd, &st0) != 0
|| sleep (1) != 0
|| read (fd, &c, 1) != 1
|| close (fd) != 0
|| stat (file, &st1) != 0
|| st0.st_atime != st1.st_atime)
status |= 64;
}
return status; }
" HAVE_WORKING_O_NOFOLLOW)

ac_source_compiles("
#include <sys/types.h>
int main() { int x = sizeof (ssize_t *) + sizeof (ssize_t);
return !x; }
" gt_cv_ssize_t)

if(NOT gt_cv_ssize_t)
    set(ssize_t int)
endif()

macro(gl_NEXT_HEADERS HEADER)
    string(TOUPPER NEXT_${HEADER} var)
    string(REGEX REPLACE "\\.|/" "_" var ${var})
    set(${var} "<${HEADER}>")
endmacro()

ac_check_funcs(fcntl)

gl_NEXT_HEADERS(errno.h)
gl_NEXT_HEADERS(fcntl.h)
gl_NEXT_HEADERS(unistd.h)
gl_NEXT_HEADERS(signal.h)
gl_NEXT_HEADERS(stddef.h)
gl_NEXT_HEADERS(stdio.h)
gl_NEXT_HEADERS(stdlib.h)
gl_NEXT_HEADERS(string.h)
gl_NEXT_HEADERS(time.h)

set(INCLUDE_NEXT "include_next")

set(GNULIB__EXIT 0)
set(GNULIB_ACCEPT 0)
set(GNULIB_ACCEPT4 0)
set(GNULIB_ATOLL 0)
set(GNULIB_BIND 0)
set(GNULIB_CALLOC_POSIX 0)
set(GNULIB_CANONICALIZE_FILE_NAME 0)
set(GNULIB_CHDIR 0)
set(GNULIB_CHOWN 0)
set(GNULIB_CLOSE 0)
set(GNULIB_CONNECT 0)
set(GNULIB_DPRINTF 0)
set(GNULIB_DUP 0)
set(GNULIB_DUP2 0)
set(GNULIB_DUP3 0)
set(GNULIB_ENVIRON 0)
set(GNULIB_EUIDACCESS 0)
set(GNULIB_FACCESSAT 0)
set(GNULIB_FCHDIR 0)
set(GNULIB_FCHMODAT 0)
set(GNULIB_FCHOWNAT 0)
set(GNULIB_FCLOSE 0)
set(GNULIB_FCNTL 0)
set(GNULIB_FDATASYNC 0)
set(GNULIB_FSYNC 0)
set(GNULIB_FFLUSH 0)
set(GNULIB_FFSL 0)
set(GNULIB_FFSLL 0)
set(GNULIB_FGETC 0)
set(GNULIB_FGETS 0)
set(GNULIB_FOPEN 0)
set(GNULIB_FPRINTF 0)
set(GNULIB_FPRINTF 1)
set(GNULIB_FPRINTF_POSIX 0)
set(GNULIB_FPURGE 0)
set(GNULIB_FPUTC 0)
set(GNULIB_FPUTS 0)
set(GNULIB_FREAD 0)
set(GNULIB_FREOPEN 0)
set(GNULIB_FSCANF 0)
set(GNULIB_FSEEK 0)
set(GNULIB_FSEEKO 0)
set(GNULIB_FSTATAT 0)
set(GNULIB_FSYNC 0)
set(GNULIB_FTELL 0)
set(GNULIB_FTELLO 0)
set(GNULIB_FTRUNCATE 0)
set(GNULIB_FUTIMENS 0)
set(GNULIB_FWRITE 0)
set(GNULIB_GETC 0)
set(GNULIB_GETCHAR 0)
set(GNULIB_GETCWD 0)
set(GNULIB_GETDELIM 0)
set(GNULIB_GETDOMAINNAME 0)
set(GNULIB_GETDTABLESIZE 0)
set(GNULIB_GETGROUPS 0)
set(GNULIB_GETHOSTNAME 0)
set(GNULIB_GETLINE 0)
set(GNULIB_GETLOADAVG 0)
set(GNULIB_GETLOGIN 0)
set(GNULIB_GETLOGIN_R 0)
set(GNULIB_GETPAGESIZE 0)
set(GNULIB_GETPEERNAME 0)
set(GNULIB_GETS 0)
set(GNULIB_GETS 1)
set(GNULIB_GETSOCKNAME 0)
set(GNULIB_GETSOCKOPT 0)
set(GNULIB_GETSUBOPT 0)
set(GNULIB_GETUSERSHELL 0)
set(GNULIB_GRANTPT 0)
set(GNULIB_GROUP_MEMBER 0)
set(GNULIB_ISATTY 0)
set(GNULIB_LCHMOD 0)
set(GNULIB_LCHOWN 0)
set(GNULIB_LINK 0)
set(GNULIB_LINKAT 0)
set(GNULIB_LISTEN 0)
set(GNULIB_LSEEK 0)
set(GNULIB_LSTAT 0)
set(GNULIB_MALLOC_POSIX 0)
set(GNULIB_MBSCASECMP 0)
set(GNULIB_MBSCASESTR 0)
set(GNULIB_MBSCHR 0)
set(GNULIB_MBSCSPN 0)
set(GNULIB_MBSLEN 0)
set(GNULIB_MBSNCASECMP 0)
set(GNULIB_MBSNLEN 0)
set(GNULIB_MBSPBRK 0)
set(GNULIB_MBSPCASECMP 0)
set(GNULIB_MBSRCHR 0)
set(GNULIB_MBSSEP 0)
set(GNULIB_MBSSPN 0)
set(GNULIB_MBSSTR 0)
set(GNULIB_MBSTOK_R 0)
set(GNULIB_MBTOWC 0)
set(GNULIB_MEMCHR 0)
set(GNULIB_MEMMEM 0)
set(GNULIB_MEMPCPY 0)
set(GNULIB_MEMRCHR 0)
set(GNULIB_MKDIRAT 0)
set(GNULIB_MKDTEMP 0)
set(GNULIB_MKFIFO 0)
set(GNULIB_MKFIFOAT 0)
set(GNULIB_MKNOD 0)
set(GNULIB_MKNODAT 0)
set(GNULIB_MKOSTEMP 0)
set(GNULIB_MKOSTEMPS 0)
set(GNULIB_MKSTEMP 0)
set(GNULIB_MKSTEMPS 0)
set(GNULIB_MKTIME 0)
set(GNULIB_NANOSLEEP 0)
set(GNULIB_NONBLOCKING 0)
set(GNULIB_OBSTACK_PRINTF 0)
set(GNULIB_OBSTACK_PRINTF_POSIX 0)
set(GNULIB_OPEN 0)
set(GNULIB_OPENAT 0)
set(GNULIB_PERROR 0)
set(GNULIB_PIPE 0)
set(GNULIB_PIPE2 0)
set(GNULIB_POPEN 0)
set(GNULIB_PREAD 0)
set(GNULIB_PRINTF 0)
set(GNULIB_PRINTF 1)
set(GNULIB_PRINTF_POSIX 0)
set(GNULIB_PTHREAD_SIGMASK 0)
set(GNULIB_PTSNAME 0)
set(GNULIB_PUTC 0)
set(GNULIB_PUTC 1)
set(GNULIB_PUTCHAR 0)
set(GNULIB_PUTCHAR 1)
set(GNULIB_PUTENV 0)
set(GNULIB_PUTS 0)
set(GNULIB_PUTS 1)
set(GNULIB_PWRITE 0)
set(GNULIB_RANDOM_R 0)
set(GNULIB_RAWMEMCHR 0)
set(GNULIB_READ 0)
set(GNULIB_READLINK 0)
set(GNULIB_READLINKAT 0)
set(GNULIB_REALLOC_POSIX 0)
set(GNULIB_REALPATH 0)
set(GNULIB_RECV 0)
set(GNULIB_RECVFROM 0)
set(GNULIB_REMOVE 0)
set(GNULIB_RENAME 0)
set(GNULIB_RENAMEAT 0)
set(GNULIB_RMDIR 0)
set(GNULIB_RPMATCH 0)
set(GNULIB_SCANF 0)
set(GNULIB_SCANF 1)
set(GNULIB_SEND 0)
set(GNULIB_SENDTO 0)
set(GNULIB_SETENV 0)
set(GNULIB_SETHOSTNAME 0)
set(GNULIB_SETSOCKOPT 0)
set(GNULIB_SHUTDOWN 0)
set(GNULIB_SIGACTION 0)
set(GNULIB_SIGNAL_H_SIGPIPE 0)
set(GNULIB_SIGPROCMASK 0)
set(GNULIB_SLEEP 0)
set(GNULIB_SNPRINTF 0)
set(GNULIB_SOCKET 0)
set(GNULIB_SPRINTF_POSIX 0)
set(GNULIB_STAT 0)
set(GNULIB_STDIO_H_NONBLOCKING 0)
set(GNULIB_STDIO_H_SIGPIPE 0)
set(GNULIB_STPCPY 0)
set(GNULIB_STPNCPY 0)
set(GNULIB_STRCASESTR 0)
set(GNULIB_STRCHRNUL 0)
set(GNULIB_STRDUP 0)
set(GNULIB_STRERROR 0)
set(GNULIB_STRERROR_R 0)
set(GNULIB_STRNCAT 0)
set(GNULIB_STRNDUP 0)
set(GNULIB_STRNLEN 0)
set(GNULIB_STRPBRK 0)
set(GNULIB_STRPTIME 0)
set(GNULIB_STRSEP 0)
set(GNULIB_STRSIGNAL 0)
set(GNULIB_STRSTR 0)
set(GNULIB_STRTOD 0)
set(GNULIB_STRTOK_R 0)
set(GNULIB_STRTOLL 0)
set(GNULIB_STRTOULL 0)
set(GNULIB_STRVERSCMP 0)
set(GNULIB_SYMLINK 0)
set(GNULIB_SYMLINKAT 0)
set(GNULIB_SYSTEM_POSIX 0)
set(GNULIB_TIME_R 0)
set(GNULIB_TIMEGM 0)
set(GNULIB_TMPFILE 0)
set(GNULIB_TTYNAME_R 0)
set(GNULIB_UNISTD_H_GETOPT 0)
set(GNULIB_UNISTD_H_NONBLOCKING 0)
set(GNULIB_UNISTD_H_SIGPIPE 0)
set(GNULIB_UNLINK 0)
set(GNULIB_UNLINKAT 0)
set(GNULIB_UNLOCKPT 0)
set(GNULIB_UNSETENV 0)
set(GNULIB_USLEEP 0)
set(GNULIB_UTIMENSAT 0)
set(GNULIB_VASPRINTF 0)
set(GNULIB_VDPRINTF 0)
set(GNULIB_VFPRINTF 0)
set(GNULIB_VFPRINTF_POSIX 0)
set(GNULIB_VFSCANF 0)
set(GNULIB_VPRINTF 0)
set(GNULIB_VPRINTF_POSIX 0)
set(GNULIB_VSCANF 0)
set(GNULIB_VSNPRINTF 0)
set(GNULIB_VSPRINTF_POSIX 0)
set(GNULIB_WCTOMB 0)
set(GNULIB_WRITE 0)
set(REPLACE_CHOWN 0)
set(REPLACE_CLOSE 0)
set(REPLACE_DUP 0)
set(REPLACE_DUP2 0)
set(REPLACE_FCHOWNAT 0)
set(REPLACE_GETCWD 0)
set(REPLACE_GETDOMAINNAME 0)
set(REPLACE_GETGROUPS 0)
set(REPLACE_GETLOGIN_R 0)
set(REPLACE_GETPAGESIZE 0)
set(REPLACE_LCHOWN 0)
set(REPLACE_LINK 0)
set(REPLACE_LINKAT 0)
set(REPLACE_LOCALTIME_R ${GNULIB_PORTCHECK})
set(REPLACE_LSEEK 0)
set(REPLACE_MKTIME ${GNULIB_PORTCHECK})
set(REPLACE_NANOSLEEP ${GNULIB_PORTCHECK})
set(REPLACE_PREAD 0)
set(REPLACE_PWRITE 0)
set(REPLACE_READ 0)
set(REPLACE_READLINK 0)
set(REPLACE_RMDIR 0)
set(REPLACE_SLEEP 0)
set(REPLACE_SYMLINK 0)
set(REPLACE_TIMEGM ${GNULIB_PORTCHECK})
set(REPLACE_TTYNAME_R 0)
set(REPLACE_UNLINK 0)
set(REPLACE_UNLINKAT 0)
set(REPLACE_USLEEP 0)
set(REPLACE_WRITE 0)
set(UNISTD_H_HAVE_WINSOCK2_H 0)
set(UNISTD_H_HAVE_WINSOCK2_H_AND_USE_SOCKETS 0)

# TODO: Check for this
set(WINDOWS_64_BIT_OFF_T 0)

set ( GNULIB_CANONICALIZE_LGPL 1 )
set ( GNULIB_SIGPIPE 1 )
set ( GNULIB_STRERROR 1 )
set ( GNULIB_TEST_CANONICALIZE_FILE_NAME 1 )
set ( GNULIB_TEST_ENVIRON 1 )
set ( GNULIB_TEST_LSTAT 1 )
set ( GNULIB_TEST_READ 1 )
set ( GNULIB_TEST_READLINK 1 )
set ( GNULIB_TEST_REALPATH 1 )
set ( GNULIB_TEST_SIGPROCMASK 1 )
set ( GNULIB_TEST_STAT 1 )
set ( GNULIB_TEST_STRERROR 1 )

set ( HAVE_VISIBILITY 1 )
set ( ICONV_CONST "" )
# set ( MALLOC_0_IS_NONNULL 1 )
# set ( HAVE_WORKING_O_NOATIME 0 )
set ( PTRDIFF_T_SUFFIX l )
set ( SIG_ATOMIC_T_SUFFIX 1 )
set ( SIZE_T_SUFFIX ul )
set ( STRERROR_R_CHAR_P 0 )
set ( USER_LABEL_PREFIX _ )
set ( USE_UNLOCKED_IO 1 )
set ( WCHAR_T_SUFFIX "" )
set ( WINT_T_SUFFIX "" )

ac_config_header(config.h.in ${CMAKE_CURRENT_BINARY_DIR}/include/config.h)

ac_config_file(include/iconv.h.build.in ${CMAKE_CURRENT_BINARY_DIR}/include/iconv.h @ONLY)
ac_config_file(include/iconv.h.in ${CMAKE_CURRENT_BINARY_DIR}/include/iconv.h.inst @ONLY)

ac_config_file(include/iconv.h.build.in ${CMAKE_CURRENT_BINARY_DIR}/include/iconv.h.build @ONLY)
ac_config_file(include/iconv.h.build.in ${CMAKE_CURRENT_BINARY_DIR}/include/iconv.h.build @ONLY)
ac_config_file(libcharset/include/libcharset.h.in ${CMAKE_CURRENT_BINARY_DIR}/libcharset/include/libcharset.h @ONLY)
ac_config_file(libcharset/include/localcharset.h.build.in ${CMAKE_CURRENT_BINARY_DIR}/libcharset/include/localcharset.h.build @ONLY)
ac_config_file(libcharset/include/localcharset.h.in ${CMAKE_CURRENT_BINARY_DIR}/libcharset/include/localcharset.h @ONLY)
ac_config_file(srclib/alloca.in.h ${CMAKE_CURRENT_BINARY_DIR}/srclib/alloca.h @ONLY)
ac_config_file(srclib/fcntl.in.h ${CMAKE_CURRENT_BINARY_DIR}/srclib/fcntl.h @ONLY)
ac_config_file(srclib/unistd.in.h ${CMAKE_CURRENT_BINARY_DIR}/srclib/unistd.h @ONLY)
ac_config_file(srclib/unitypes.in.h ${CMAKE_CURRENT_BINARY_DIR}/srclib/unitypes.h @ONLY)
ac_config_file(srclib/uniwidth.in.h ${CMAKE_CURRENT_BINARY_DIR}/srclib/uniwidth.h @ONLY)

include_directories(${CMAKE_CURRENT_BINARY_DIR}/include ${CMAKE_CURRENT_BINARY_DIR}/srclib ${CMAKE_CURRENT_SOURCE_DIR} include srclib )
add_definitions( -Dset_relocation_prefix=libcharset_set_relocation_prefix -Drelocate=libcharset_relocate -DHAVE_CONFIG_H -DINSTALLPREFIX=NULL -DNO_XMALLOC -DBUILDING_LIBCHARSET -DINSTALLDIR="" -DLIBDIR="" -DENABLE_RELOCATABLE=1 -DIN_LIBRARY )


add_library(charset libcharset/lib/localcharset.c libcharset/lib/relocatable.c)
target_compile_options(charset PRIVATE -DBUILDING_LIBCHARSET)

# if ( NOT MSVC )
#   # libicrt
#   set ( SRC_LIBICRT 
#     srclib/allocator.c
#     srclib/areadlink.c
#     srclib/careadlinkat.c
#     srclib/malloca.c
#     srclib/progname.c
#     srclib/safe-read.c
#     srclib/uniwidth/width.c
#     srclib/xmalloc.c
#     srclib/xstrdup.c
#     srclib/xreadlink.c
#     srclib/canonicalize-lgpl.c
#     srclib/error.c
#     srclib/lstat.c
#     srclib/readlink.c
#     srclib/stat.c
#     srclib/strerror.c
#     srclib/strerror-override.c  
#   )
#   add_library ( icrt STATIC ${SRC_LIBICRT} )
# endif()
# libiconv


set ( SRC_LIBICONV
    lib/iconv.c
    srclib/allocator.c
    srclib/areadlink.c
    srclib/careadlinkat.c
    srclib/malloca.c
    srclib/progname.c
    srclib/safe-read.c
    srclib/uniwidth/width.c
    srclib/xmalloc.c
    srclib/xreadlink.c
    srclib/xstrdup.c
)
append_prefix(srclib/ SRC_LIBICONV ${AC_LIBSRCS})

add_library(iconv ${SRC_LIBICONV})
target_link_libraries(iconv charset)
set_target_properties(iconv PROPERTIES COMPILE_FLAGS -DBUILDING_LIBICONV)

if(NOT MSVC)
    add_executable(iconvcli src/iconv_no_i18n.c)
    target_link_libraries(iconvcli iconv charset)
    set_target_properties(iconvcli PROPERTIES OUTPUT_NAME iconv)

    install(TARGETS iconvcli DESTINATION bin)
endif()

# fix library naming for Visual Studio compilers
if(MSVC)
  set_target_properties ( iconv   PROPERTIES OUTPUT_NAME "libiconv" )
  set_target_properties ( charset PROPERTIES OUTPUT_NAME "libcharset" )
endif()

install(TARGETS iconv charset 
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/include/iconv.h 
    ${CMAKE_CURRENT_BINARY_DIR}/libcharset/include/libcharset.h
    ${CMAKE_CURRENT_BINARY_DIR}/libcharset/include/localcharset.h
    DESTINATION include)


