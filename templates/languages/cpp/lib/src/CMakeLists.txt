# variables
file(GLOB_RECURSE ${PROJECT_NAME}_sources CONFIGURE_DEPENDS *.cpp)
file(GLOB_RECURSE ${PROJECT_NAME}_headers CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/include/*.h)

# targets and outputs
add_library(${PROJECT_NAME}
    ${${PROJECT_NAME}_sources}
    ${${PROJECT_NAME}_headers}
    )
set_target_properties(${PROJECT_NAME} PROPERTIES
    SOVERSION ${PROJECT_VERSION}
    PUBLIC_HEADER "${${PROJECT_NAME}_headers}"
    )

# installations
install(TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    PUBLIC_HEADER DESTINATION include/${PROJECT_NAME}
    )
