cmake_minimum_required(VERSION 2.8)

project(formatxx)

add_library(formatxx
    source/format.cc
)
install(DIRECTORY include/ DESTINATION include)
install(TARGETS formatxx DESTINATION lib)
target_include_directories(formatxx PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/include")
