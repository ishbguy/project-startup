# variables
file(GLOB_RECURSE ${PROJECT_NAME}_sources CONFIGURE_DEPENDS *.cpp)
file(GLOB_RECURSE ${PROJECT_NAME}_headers CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/include/*.h)

# targets and outputs
add_executable(${PROJECT_NAME}
    ${${PROJECT_NAME}_sources}
    ${${PROJECT_NAME}_headers}
    )

# installations
install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
    )
