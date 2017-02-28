
if(NOT MSVC)
    add_definitions(-std=c++0x)
endif()

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
add_library(tz tz.cpp)
install(TARGETS tz DESTINATION lib)

file(GLOB HEADERS *.h)
install(FILES ${HEADERS} DESTINATION include/date)

enable_testing()
