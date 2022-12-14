include(FindPkgConfig)
macro(_export SUFFIX)
	if(DEFINED ${REQUIRE}_${SUFFIX})
		set(${UREQUIRE}_${SUFFIX} ${${REQUIRE}_${SUFFIX}} PARENT_SCOPE)
	elseif(DEFINED ${UREQUIRE}_${SUFFIX})
		set(${UREQUIRE}_${SUFFIX} ${${UREQUIRE}_${SUFFIX}} PARENT_SCOPE)
	endif()
endmacro()

macro(_exportLibraries SUFFIX)
	set(IS_FRAMEWORK OFF)
	set(LIBS)
	if(DEFINED ${REQUIRE}_${SUFFIX})
		set(PREFIX ${REQUIRE})
	elseif(DEFINED ${UREQUIRE}_${SUFFIX})
		set(PREFIX ${UREQUIRE})
	endif()
	foreach(LIB IN LISTS ${PREFIX}_${SUFFIX})
		if(LIB STREQUAL "-framework")
			set(IS_FRAMEWORK ON)
		elseif(IS_FRAMEWORK)
			list(APPEND LIBS "-framework ${LIB}")
			set(IS_FRAMEWORK OFF)
		else()
			list(APPEND LIBS ${LIB})
		endif()
	endforeach()
	unset(PREFIX)
	set(${UREQUIRE}_${SUFFIX} ${LIBS} PARENT_SCOPE)
endmacro()

function(find_feature FEATURE_NAME FEATURE_REQUIRES)
	if (NOT ${FEATURE_NAME})
		return()
	endif()
	if (DISABLE_DEPS)
		set(${FEATURE_NAME} OFF PARENT_SCOPE)
		return()
	endif()
	if(ARGV2)
		set(VERSION "${ARGV2}")
		set(FIND_VERSION "${VERSION}" EXACT)
		set(PKG_CONFIG_VERSION_CHECK " >=${VERSION}")
	else()
		set(VERSION)
		set(FIND_VERSION)
		set(PKG_CONFIG_VERSION_CHECK)
	endif()
	foreach(NAMES ${FEATURE_REQUIRES})
		string(REPLACE "|" ";" NAMELIST "${NAMES}")
		set(FOUND OFF)
		foreach(REQUIRE ${NAMELIST})
			if(NOT ${REQUIRE}_FOUND)
				find_package(${REQUIRE} ${FIND_VERSION} QUIET)
				if(NOT ${REQUIRE}_FOUND)
					pkg_search_module(${REQUIRE} "${REQUIRE}${PKG_CONFIG_VERSION_CHECK}")
				endif()
			endif()
			if(${REQUIRE}_FOUND)
				string(TOUPPER ${REQUIRE} UREQUIRE)
				_export(CFLAGS_OTHER)
				_export(FOUND)
				_export(INCLUDE_DIRS)
				_export(INCLUDE_DIR)
				_export(VERSION_STRING)
				_export(VERSION_MAJOR)
				_export(VERSION_MINOR)
				if (APPLE)
					_exportLibraries(LIBRARIES)
					_exportLibraries(STATIC_LIBRARIES)
				else()
					_export(LIBRARIES)
					_export(STATIC_LIBRARIES)
				endif()
				_export(LIBRARY_DIRS)
				_export(LDFLAGS_OTHER)
				set(FOUND ON)
				break()
			endif()
		endforeach()

		if (NOT FOUND)
			message(WARNING "Requested module ${NAMES} missing for feature ${FEATURE_NAME}. Feature disabled.")
			set(${FEATURE_NAME} OFF PARENT_SCOPE)
			return()
		endif()
	endforeach()
endfunction()
