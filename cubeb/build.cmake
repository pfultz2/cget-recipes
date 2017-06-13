cmake_minimum_required(VERSION 2.8)

# Declare a dummy sanitizer function simply as a way to disable sanitizers (in lieu of an official
# variable to disable them), just so the sanitizer git submodule is no longer needed.
#
function(add_sanitizers ...)
	# Do nothing.
endfunction(add_sanitizers)

# nb. Tests are also disabled for the same reason as sanitizers (can't easily download the git
# submodules), but seems as that does have an official variable it's done via build.txt instead.

# Disable the Jack backend on Mac OS as it doesn't compile properly.
#
if (APPLE)
	set(USE_JACK 0)
endif (APPLE)

include(${CGET_CMAKE_ORIGINAL_SOURCE_FILE})

