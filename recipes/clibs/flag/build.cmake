cmake_minimum_required(VERSION 2.8)
project(flag)
file(GLOB_RECURSE SOURCES flag.c flag.cpp flag.cc flag.cxx)
file(GLOB_RECURSE HEADERS flag.h flag.hpp flag.hh flag.hxx)
add_library(flag ${SOURCES})
install(TARGETS flag DESTINATION lib)
install(FILES ${HEADERS} DESTINATION include)
