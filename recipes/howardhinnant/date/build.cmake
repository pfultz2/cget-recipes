
if(NOT MSVC)
    add_definitions(-std=c++0x)
endif()

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
add_library(tz src/tz.cpp)
install(TARGETS tz DESTINATION lib)

install(DIRECTORY include/ DESTINATION include)

enable_testing()
