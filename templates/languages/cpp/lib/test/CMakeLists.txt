file(GLOB_RECURSE test_sources CONFIGURE_DEPENDS "*.cpp")

# find local criterion library first, if it is not found, download it
find_package(PkgConfig)
pkg_check_modules(CRT criterion)
if(CRT_FOUND)
    add_executable(test-${PROJECT_NAME} ${test_sources})
    target_link_libraries(test-${PROJECT_NAME} ${PROJECT_NAME} ${CRT_LIBRARIES})
else()
    include(ExternalProject)
    ExternalProject_Add(criterion
        PREFIX ${CMAKE_CURRENT_BINARY_DIR}/deps
        INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/install
        GIT_REPOSITORY https://github.com/Snaipe/Criterion
        GIT_TAG master
        UPDATE_DISCONNECTED ON
        CMAKE_ARGS -D CMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        )

    get_filename_component(test_install_lib_full_path
        ${CMAKE_CURRENT_BINARY_DIR}/install/lib ABSOLUTE
        )
    add_executable(test-${PROJECT_NAME} ${test_sources})
    include_directories(${CMAKE_CURRENT_BINARY_DIR}/install/include)
    target_link_libraries(test-${PROJECT_NAME}
        ${PROJECT_NAME}
        ${test_install_lib_full_path}/$<IF:$<BOOL:${WIN32}>,criterion.dll,libcriterion.so>
        )
    add_dependencies(test-${PROJECT_NAME} ${PROJECT_NAME} criterion)
endif()
add_test(NAME test-${PROJECT_NAME} COMMAND test-${PROJECT_NAME})
