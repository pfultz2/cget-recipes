cmake_minimum_required(VERSION 2.8)

function(patch_file FILE MATCH REPLACEMENT)
    message(STATUS "Patch: ${FILE}")
    file(READ ${FILE} CONTENT)
    string(REPLACE 
        "${MATCH}"
        "${REPLACEMENT}" 
        OUTPUT_CONTENT "${CONTENT}")
    file(WRITE ${FILE} "${OUTPUT_CONTENT}")
endfunction()

project(fftw)
set (FFTW_VERSION 3.3.5)
option (ENABLE_SSE2 "Compile with SSE2 instruction set support" OFF)

include ( CheckFunctionExists )
include ( CheckIncludeFiles )
include ( CheckTypeSize )
include ( CheckPrototypeDefinition )
include ( CheckSymbolExists )

set(CONFIG_VARS)
macro(set_config VAR)
    set(${VAR} ${ARGN})
    list(APPEND CONFIG_VARS ${VAR})
endmacro()
macro(fftw_check_include_files INCLUDE VAR)
    check_include_files(${INCLUDE} ${VAR})
    list(APPEND CONFIG_VARS ${VAR})
endmacro()

macro(fftw_check_function_exists FUNC VAR)
    check_function_exists(${FUNC} ${VAR})
    list(APPEND CONFIG_VARS ${VAR})
endmacro()

macro(fftw_check_symbol_exists FUNC HEADER VAR)
    check_symbol_exists(${FUNC} ${HEADER} ${VAR})
    list(APPEND CONFIG_VARS ${VAR})
endmacro()

macro(fftw_check_prototype_definition FUNC SIG VAL HEADER VAR)
    check_prototype_definition(${FUNC} ${SIG} ${VAL} ${HEADER} ${VAR})
    list(APPEND CONFIG_VARS ${VAR})
endmacro()

set(CONFIG_VALUE_VARS)
macro(set_config_value VAR)
    set(${VAR} ${ARGN})
    list(APPEND CONFIG_VALUE_VARS ${VAR})
endmacro()
macro(fftw_check_type_size TYPE VAR)
    check_type_size(${TYPE} ${VAR})
    list(APPEND CONFIG_VALUE_VARS ${VAR})
endmacro()

set(CONFIG_QUOTED_VARS)
macro(set_config_quote VAR)
    set(${VAR} ${ARGN})
    list(APPEND CONFIG_QUOTED_VARS ${VAR})
endmacro()

fftw_check_include_files (alloca.h         HAVE_ALLOCA_H)
fftw_check_include_files (altivec.h        HAVE_ALTIVEC_H)
fftw_check_include_files (c_asm.h          HAVE_C_ASM_H)
fftw_check_include_files (dlfcn.h          HAVE_DLFCN_H)
fftw_check_include_files (intrinsics.h     HAVE_INTRINSICS_H)
fftw_check_include_files (inttypes.h       HAVE_INTTYPES_H)
fftw_check_include_files (libintl.h        HAVE_LIBINTL_H)
fftw_check_include_files (limits.h         HAVE_LIMITS_H)
fftw_check_include_files (mach/mach_time.h HAVE_MACH_MACH_TIME_H)
fftw_check_include_files (malloc.h         HAVE_MALLOC_H)
fftw_check_include_files (memory.h         HAVE_MEMORY_H)
fftw_check_include_files (stddef.h         HAVE_STDDEF_H)
fftw_check_include_files (stdint.h         HAVE_STDINT_H)
fftw_check_include_files (stdlib.h         HAVE_STDLIB_H)
fftw_check_include_files (string.h         HAVE_STRING_H)
fftw_check_include_files (strings.h        HAVE_STRINGS_H)
fftw_check_include_files (sys/types.h      HAVE_SYS_TYPES_H)
fftw_check_include_files (sys/time.h       HAVE_SYS_TIME_H)
fftw_check_include_files (sys/stat.h       HAVE_SYS_STAT_H)
fftw_check_include_files (sys/sysctl.h     HAVE_SYS_SYSCTL_H)
fftw_check_include_files (time.h           HAVE_TIME_H)
fftw_check_include_files (uintptr.h        HAVE_UINTPTR_H)
fftw_check_include_files (unistd.h         HAVE_UNISTD_H)
if (HAVE_TIME_H AND HAVE_SYS_TIME_H)
  set_config (TIME_WITH_SYS_TIME TRUE)
endif ()

fftw_check_prototype_definition (drand48 "double drand48 (void)" "0" stdlib.h HAVE_DECL_DRAND48)
fftw_check_prototype_definition (srand48 "void srand48(long int seedval)" "0" stdlib.h HAVE_DECL_SRAND48)
fftw_check_prototype_definition (cosl math.h "long double cosl(long double x)" "1" HAVE_DECL_COSL)
# fftw_check_prototype_definition (cosq math.h HAVE_DECL_COSQ)
fftw_check_prototype_definition (memalign "void *memalign(size_t alignment, size_t size)" "0" malloc.h HAVE_DECL_MEMALIGN)
fftw_check_prototype_definition (posix_memalign "int posix_memalign(void **memptr, size_t alignment, size_t size)" "0" stdlib.h HAVE_DECL_POSIX_MEMALIGN)


# fftw_check_prototype_definition (sinl math.h HAVE_DECL_SINL)
# fftw_check_prototype_definition (sinq math.h HAVE_DECL_SINQ)

fftw_check_symbol_exists (clock_gettime sys/time.h HAVE_CLOCK_GETTIME)
fftw_check_symbol_exists (gettimeofday sys/time.h HAVE_GETTIMEOFDAY)
fftw_check_symbol_exists (drand48 stdlib.h HAVE_DRAND48)
fftw_check_symbol_exists (srand48 stdlib.h HAVE_SRAND48)
fftw_check_symbol_exists (memalign malloc.h HAVE_MEMALIGN)
fftw_check_symbol_exists (posix_memalign stdlib.h HAVE_POSIX_MEMALIGN)
fftw_check_symbol_exists (mach_absolute_time mach/mach_time.h HAVE_MACH_ABSOLUTE_TIME)
fftw_check_symbol_exists (uintptr_t stdint.h HAVE_UINTPTR_T)

fftw_check_type_size(char SIZEOF_CHAR)
fftw_check_type_size(int SIZEOF_INT)
fftw_check_type_size(long SIZEOF_LONG)
fftw_check_type_size("long long" SIZEOF_LONG_LONG)
fftw_check_type_size("unsigned long long" SIZEOF_UNSIGNED_LONG_LONG)
fftw_check_type_size("unsigned long" SIZEOF_UNSIGNED_LONG)
fftw_check_type_size("unsigned int" SIZEOF_UNSIGNED_INT)
fftw_check_type_size(short SIZEOF_SHORT)
fftw_check_type_size(size_t SIZEOF_SIZE_T)
fftw_check_type_size(ptrdiff_t SIZEOF_PTRDIFF_T)
set_config_value(SIZEOF_VOID_P ${CMAKE_SIZEOF_VOID_P})
set_config_quote(PACKAGE "fftw")
set_config_quote(PACKAGE_VERSION ${FFTW_VERSION})
set_config_quote(FFTW_CC "${CMAKE_C_COMPILER} ${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_${CMAKE_BUILD_TYPE}}")
set_config_quote(VERSION ${FFTW_VERSION})

if (UNIX)
  set_config (HAVE_LIBM TRUE)
endif ()

find_package (Threads)
if (Threads_FOUND)
  if(CMAKE_USE_PTHREADS_INIT)
    set_config (USING_POSIX_THREADS 1)
  endif ()
  set_config (HAVE_THREADS TRUE)
endif ()

if (ENABLE_SSE2)
  set_config (HAVE_SSE2 TRUE)
endif ()

if (ENABLE_SSE2 OR ENABLE_AVX)
  set_config (HAVE_SIMD TRUE)
endif ()

patch_file(config.h.in "#undef" "#cmakedefine")
foreach(VAR ${CONFIG_VARS})
    if(${VAR})
        patch_file(config.h.in "#cmakedefine ${VAR}" "#define ${VAR} 1")
    endif()
endforeach()

foreach(VAR ${CONFIG_VALUE_VARS})
    patch_file(config.h.in "#cmakedefine ${VAR}\n" "#define ${VAR} @${VAR}@\n")
endforeach()

foreach(VAR ${CONFIG_QUOTED_VARS})
    patch_file(config.h.in "#cmakedefine ${VAR}\n" "#define ${VAR} \"@${VAR}@\"\n")
endforeach()

configure_file (config.h.in ${CMAKE_CURRENT_BINARY_DIR}/config.h @ONLY)
include_directories (${CMAKE_CURRENT_BINARY_DIR})

set (SOURCEFILES)
macro (fftw_add_source_file)
    file(GLOB sf ${ARGN})
    list(APPEND SOURCEFILES ${sf})
endmacro()

fftw_add_source_file(
    api/*.c
    dft/*.c
    dft/scalar/*.c
    dft/scalar/codelets/*.c
    kernel/*.c
    # libbench2/*.c
    rdft/*.c
    rdft/scalar/*.c
    rdft/scalar/r2cb/*.c
    rdft/scalar/r2cf/*.c
    rdft/scalar/r2r/*.c
    reodft/*.c
)
# fftw_add_source_file(simd-support/*.c)

if (Threads_FOUND)
  fftw_add_source_file(
    threads/api.c
    threads/conf.c
    threads/threads.c
    threads/dft-vrank-geq1.c
    threads/ct.c
    threads/rdft-vrank-geq1.c
    threads/hc2hc.c
    threads/vrank-geq1-rdft2.c
    threads/f77api.c)
endif ()

if (OpenMP_FOUND)
  fftw_add_source_file(
    threads/api.c
    threads/conf.c
    threads/openmp.c
    threads/dft-vrank-geq1.c
    threads/ct.c
    threads/rdft-vrank-geq1.c
    threads/hc2hc.c
    threads/vrank-geq1-rdft2.c
    threads/f77api.c)
endif ()

include_directories(
    api/
    dft/
    dft/scalar/
    kernel/
    # libbench2/
    rdft/
    rdft/scalar/
    reodft/
    simd-support/
    threads/)

add_library (fftw3 ${SOURCEFILES})
if (HAVE_LIBM)
  target_link_libraries (fftw3 m)
endif ()
if (Threads_FOUND)
  target_link_libraries (fftw3 ${CMAKE_THREAD_LIBS_INIT})
endif ()
set_target_properties (fftw3 PROPERTIES SOVERSION 3.5.5 VERSION 3)

install (TARGETS fftw3
         RUNTIME DESTINATION bin
         LIBRARY DESTINATION lib
         ARCHIVE DESTINATION lib)

install(FILES api/fftw3.h DESTINATION include)

set(prefix ${CMAKE_INSTALL_PREFIX})
set(exec_prefix ${CMAKE_INSTALL_PREFIX})
set(libdir ${CMAKE_INSTALL_PREFIX}/lib)
set(includedir ${CMAKE_INSTALL_PREFIX}/include)
configure_file(fftw.pc.in ${CMAKE_BINARY_DIR}/fftw.pc @ONLY)
install(FILES ${CMAKE_BINARY_DIR}/fftw.pc DESTINATION lib/pkgconfig)
install(FILES ${CMAKE_BINARY_DIR}/fftw.pc DESTINATION lib/pkgconfig RENAME fftw3.pc)

enable_testing ()

add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure -C ${CMAKE_CFG_INTDIR})

add_executable (bench EXCLUDE_FROM_ALL 
    tests/bench.c 
    tests/hook.c 
    tests/fftw-bench.c
    libbench2/after-ccopy-from.c
    libbench2/after-ccopy-to.c
    libbench2/after-hccopy-from.c
    libbench2/after-hccopy-to.c
    libbench2/after-rcopy-from.c
    libbench2/after-rcopy-to.c
    libbench2/allocate.c
    libbench2/aset.c
    libbench2/bench-cost-postprocess.c
    libbench2/bench-exit.c
    libbench2/bench-main.c
    libbench2/can-do.c
    libbench2/caset.c
    libbench2/dotens2.c
    libbench2/info.c
    libbench2/main.c
    libbench2/mflops.c
    libbench2/mp.c
    libbench2/my-getopt.c
    libbench2/ovtpvt.c
    libbench2/pow2.c
    libbench2/problem.c
    libbench2/report.c
    libbench2/speed.c
    libbench2/tensor.c
    libbench2/timer.c
    # libbench2/useropt.c
    libbench2/util.c
    libbench2/verify.c
    libbench2/verify-dft.c
    libbench2/verify-lib.c
    libbench2/verify-r2r.c
    libbench2/verify-rdft2.c
    libbench2/zero.c
)
target_include_directories(bench PUBLIC libbench2/)
target_link_libraries (bench fftw3)

add_custom_target (tests)
add_dependencies(check tests)
add_dependencies (tests bench)

macro (fftw_add_test problem)
  add_test (NAME ${problem} COMMAND $<TARGET_FILE:bench> -s ${problem})
endmacro ()

fftw_add_test (32x64)
fftw_add_test (ib256)
