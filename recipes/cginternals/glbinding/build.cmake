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

# MSVC 2015 crashes when adding the /GL flag
# See https://gitlab.kitware.com/cmake/cmake/issues/16282
patch_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/CompileOptions.cmake "/GL" " ")
# patch_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/CompileOptions.cmake "/Gw" " ")

include(${CGET_CMAKE_ORIGINAL_SOURCE_FILE})
