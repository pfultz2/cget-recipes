cmake_minimum_required(VERSION 2.8)

if(UNIX)
    # Make sure its executable
    execute_process(COMMAND chmod +x ${CMAKE_CURRENT_SOURCE_DIR}/tools/build/bootstrap.sh)
    execute_process(COMMAND chmod +x ${CMAKE_CURRENT_SOURCE_DIR}/tools/build/src/engine/build.sh)
endif()

include(${CGET_CMAKE_DIR}/boost.cmake)
