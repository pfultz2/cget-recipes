
set(prefix ${CMAKE_INSTALL_PREFIX})
set(exec_prefix ${CMAKE_INSTALL_PREFIX})
set(libdir ${CMAKE_INSTALL_PREFIX}/lib)
set(includedir ${CMAKE_INSTALL_PREFIX}/include)
configure_file(sqlite3.pc.in sqlite3.pc)

include_directories(${CMAKE_SOURCE_DIR})
add_library(sqlite3 sqlite3.c)

install(FILES sqlite3.h DESTINATION include)
install(FILES ${CMAKE_BINARY_DIR}/sqlite3.pc DESTINATION lib)
install(TARGETS sqlite3 DESTINATION lib)
