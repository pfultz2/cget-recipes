cmake_minimum_required(VERSION 2.8)


if(UNIX)
    # Make sure its executable
    execute_process(COMMAND chmod +x ${CMAKE_CURRENT_SOURCE_DIR}/tools/build/bootstrap.sh)
    execute_process(COMMAND chmod +x ${CMAKE_CURRENT_SOURCE_DIR}/tools/build/src/engine/build.sh)
endif()

# See:
# https://github.com/boostorg/asio/pull/45
# https://github.com/chriskohlhoff/asio/issues/85
# https://svn.boost.org/trac/boost/ticket/12575
function(patch_asio)
    set(ASIO_SSL_CONTEXT_FILE ${CMAKE_CURRENT_SOURCE_DIR}/boost/asio/ssl/impl/context.ipp)
    message(STATUS "Patch: ${ASIO_SSL_CONTEXT_FILE}")
    file(READ ${ASIO_SSL_CONTEXT_FILE} CONTENT)
    string(REPLACE 
        "OPENSSL_VERSION_NUMBER >= 0x10100000L"
        "OPENSSL_VERSION_NUMBER >= 0x10100000L && !defined(LIBRESSL_VERSION_NUMBER)" 
        OUTPUT_CONTENT "${CONTENT}")
    file(WRITE ${ASIO_SSL_CONTEXT_FILE} "${OUTPUT_CONTENT}")
endfunction()

patch_asio()
include(${CGET_CMAKE_DIR}/boost.cmake)
