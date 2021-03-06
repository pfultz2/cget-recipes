cmake_minimum_required(VERSION 2.8)
project(netstring)
file(GLOB_RECURSE SOURCES netstring.c netstring.cpp netstring.cxx)
file(GLOB_RECURSE HEADERS netstring.h netstring.hpp netstring.hxx)
add_library(netstring ${SOURCES})
install(TARGETS netstring DESTINATION lib)
install(FILES ${HEADERS} DESTINATION include)
