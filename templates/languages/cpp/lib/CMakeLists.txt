# project informations
cmake_minimum_required(VERSION 3.2)
project(PROJECT-NAME VERSION 0.0.1 LANGUAGES CXX)

# options
option(BUILD_SHARED_LIBS "Build ${PROJECT_NAME} as a shared library." ON)
option(MAKE_TEST "Build ${PROJECT_NAME} tests" OFF)

# variables
# set(CMAKE_BUILD_TYPE "Release")
set(CMAKE_INSTALL_PREFIX /usr)
set(${PROJECT_NAME}_install_library_dir ${CMAKE_INSTALL_PREFIX}/lib)
set(${PROJECT_NAME}_install_include_dir ${CMAKE_INSTALL_PREFIX}/include/${PROJECT_NAME})

# compile flags
# set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wno-discarded-qualifiers")
include_directories(include)

add_subdirectory(src)

if(${MAKE_TEST})
    enable_testing()
    add_subdirectory(test)
endif()

# installations
configure_file(${PROJECT_NAME}.pc.in ${PROJECT_NAME}.pc)
install(FILES ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.pc
    DESTINATION lib/pkgconfig
    )

# custom targets
set(manifest ${CMAKE_BINARY_DIR}/install_manifest.txt)
if(EXISTS ${manifest})
    file(STRINGS ${manifest} install_files)
else()
    set(install_files "")
endif()
add_custom_target(uninstall
    COMMAND "${CMAKE_COMMAND}" -E remove ${install_files}
    )
