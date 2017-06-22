cmake_minimum_required(VERSION 2.8.12)

include(${CGET_CMAKE_ORIGINAL_SOURCE_FILE})

install(TARGETS freetype-gl DESTINATION lib)
install(FILES ${FREETYPE_GL_HDR} DESTINATION include)

