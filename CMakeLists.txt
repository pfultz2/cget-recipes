
file(GLOB RECIPES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} recipes/*)

macro(get_directory_base OUTPUT_VAR DIR)
    if(CMAKE_VERSION VERSION_LESS "3.0")
        get_filename_component(${OUTPUT_VAR} ${DIR} PATH ${ARGN})
    else()
        get_filename_component(${OUTPUT_VAR} ${DIR} DIRECTORY ${ARGN})
    endif()
endmacro()

foreach(RECIPE ${RECIPES})
    get_directory_base(RECIPE_DIR ${RECIPE})
    install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${RECIPE} DESTINATION etc/cget/recipes/)
    # message(STATUS "RECIPE: ${RECIPE}")
    # message(STATUS "RECIPE_DIR: ${RECIPE_DIR}")
endforeach()

install(DIRECTORY cmake DESTINATION share/)

enable_testing()

