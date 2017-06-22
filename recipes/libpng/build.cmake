cmake_minimum_required(VERSION 2.8)

if(BUILD_SHARED_LIBS)
    set(PNG_SHARED On CACHE BOOL "")
    set(PNG_STATIC Off CACHE BOOL "")
else()
    set(PNG_SHARED Off CACHE BOOL "")
    set(PNG_STATIC On CACHE BOOL "")
endif()
if(BUILD_TESTING)
    set(PNG_TESTS On CACHE BOOL "")
else()
    set(PNG_TESTS Off CACHE BOOL "")
endif()

# Use the prebuilt pnglibconf header (by copying it into place and renaming it) when building
# as a static lib, to prevent potential 'ZLIB_VERNUM != PNG_ZLIB_VERNUM' errors that can be
# caused if a different version of the header is found elsewhere in the include paths.
if(NOT BUILD_SHARED_LIBS)
	file(COPY ${Project_SOURCE_DIR}/scripts/pnglibconf.h.prebuilt DESTINATION ${Project_SOURCE_DIR})
	file(RENAME ${Project_SOURCE_DIR}/pnglibconf.h.prebuilt ${Project_SOURCE_DIR}/pnglibconf.h)
endif()

include(${CGET_CMAKE_ORIGINAL_SOURCE_FILE})

if(MSVC)
    set(prefix      ${CMAKE_INSTALL_PREFIX})
    set(exec_prefix ${CMAKE_INSTALL_PREFIX})
    set(libdir      ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR})
    set(includedir  ${CMAKE_INSTALL_PREFIX}/include)
    set(LIBS        "-lz -lm")
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/libpng.pc.in
        ${CMAKE_CURRENT_BINARY_DIR}/${PNGLIB_NAME}.pc @ONLY)
    CREATE_SYMLINK(${PNGLIB_NAME}.pc libpng.pc)

    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/libpng-config.in
        ${CMAKE_CURRENT_BINARY_DIR}/${PNGLIB_NAME}-config @ONLY)
    CREATE_SYMLINK(${PNGLIB_NAME}-config libpng-config)

    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/libpng.pc
            DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig)
    install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/libpng-config
            DESTINATION bin)
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PNGLIB_NAME}.pc
            DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig)
    install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/${PNGLIB_NAME}-config
            DESTINATION bin)

    if(PNG_STATIC)
        set_target_properties(png_static PROPERTIES
              OUTPUT_NAME "${PNG_LIB_NAME}"
        CLEAN_DIRECT_OUTPUT 1)
        get_target_property(BUILD_TARGET_LOCATION png_static LOCATION_${CMAKE_BUILD_TYPE})
        CREATE_SYMLINK(${BUILD_TARGET_LOCATION} libpng${CMAKE_STATIC_LIBRARY_SUFFIX})
        install(FILES ${CMAKE_CURRENT_BINARY_DIR}/libpng${CMAKE_STATIC_LIBRARY_SUFFIX}
            DESTINATION ${CMAKE_INSTALL_LIBDIR})
    endif()
    if(PNG_SHARED)
        # Create a symlink for libpng.dll.a => libpng16.dll.a on Cygwin
       get_target_property(BUILD_TARGET_LOCATION png LOCATION_${CMAKE_BUILD_TYPE})
       CREATE_SYMLINK(${BUILD_TARGET_LOCATION} libpng${CMAKE_IMPORT_LIBRARY_SUFFIX})
       install(FILES ${CMAKE_CURRENT_BINARY_DIR}/libpng${CMAKE_IMPORT_LIBRARY_SUFFIX}
         DESTINATION ${CMAKE_INSTALL_LIBDIR})
    endif()
endif()
