cmake_minimum_required(VERSION 2.8.0)
project(mumlib)

# Version
set (mumlib_VERSION_MAJOR 0)
set (mumlib_VERSION_MINOR 2)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
add_definitions(-DOPT_TLS_GNUTLS -D_POSIX_C_SOURCE=200112L)

INCLUDE(FindPkgConfig)
find_package(PkgConfig REQUIRED)
find_package(Boost COMPONENTS system REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(Protobuf REQUIRED)

pkg_check_modules(LOG4CPP "log4cpp")
pkg_check_modules(OPUS "opus")


INCLUDE_DIRECTORIES(${Boost_INCLUDE_DIR})
include_directories(${OPENSSL_INCLUDE_DIR})
include_directories(${PROTOBUF_INCLUDE_DIRS})
include_directories(${OPUS_INCLUDE_DIRS})

include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${LOG4CPP_INCLUDE_DIRS})
include_directories(include)

set(MUMLIB_PUBLIC_HEADERS include/mumlib.hpp include/mumlib/VarInt.hpp)

set(MUMLIB_PRIVATE_HEADERS
        include/mumlib/Callback.hpp
        include/mumlib/CryptState.hpp
        include/mumlib/Transport.hpp
        include/mumlib/Audio.hpp
        include/mumlib/enums.hpp
        )

set(MUMLIB_SRC
        src/mumlib.cpp
        src/Callback.cpp
        src/CryptState.cpp
        src/VarInt.cpp
        src/Transport.cpp
        src/Audio.cpp
        )

PROTOBUF_GENERATE_CPP(PROTO_SRCS PROTO_HDRS Mumble.proto)

add_library(mumlib SHARED ${MUMLIB_SRC} ${MUMLIB_PUBLIC_HEADERS} ${MUMLIB_PRIVATE_HEADERS} ${PROTO_SRCS} ${PROTO_HDRS})
target_link_libraries(mumlib ${PROTOBUF_LIBRARIES})
target_link_libraries(mumlib ${Boost_LIBRARIES})
target_link_libraries(mumlib ${OPENSSL_LIBRARIES})
target_link_libraries(mumlib ${LOG4CPP_LIBRARIES})
target_link_libraries(mumlib ${OPUS_LIBRARIES})

add_executable(mumlib_example mumlib_example.cpp)
target_link_libraries(mumlib_example mumlib)

install(TARGETS mumlib LIBRARY DESTINATION lib)
install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/include/mumlib.hpp" DESTINATION include)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/include/mumlib/VarInt.hpp DESTINATION include/mumlib)

INCLUDE(InstallRequiredSystemLibraries)

SET(CPACK_PACKAGE_NAME "mumlib")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "mumlib")
SET(CPACK_PACKAGE_VENDOR "Scott Hardin")
SET(CPACK_PACKAGE_CONTACT "Scott Hardin <mrscotty@github.com>")
SET(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/Description.txt")
#SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/Copyright.txt")
SET(CPACK_PACKAGE_VERSION_MAJOR "${mumlib_VERSION_MAJOR}")
SET(CPACK_PACKAGE_VERSION_MINOR "${mumlib_VERSION_MINOR}")
SET(CPACK_PACKAGE_VERSION_PATCH "0")
SET(CPACK_PACKAGE_INSTALL_DIRECTORY "CMake $ {Cmake_VERSION_MAJOR}.${CMake_VERSION_MINOR}")

# Debian Package Build
#SET(CPACK_DEBIAN_PACKAGE_DEPENDS "${shlibs:Depends}, ${misc:Depends}")
SET(CPACK_DEBIAN_PACKAGE_SECTION "libs")
SET(CPACK_DEBIAN_PACKAGE_BUILD_DEPENDS "debhelper (>= 9), cmake, libboost-all-dev, libssl1.0.2, libssl1.0-dev, liblog4cpp5v5, liblog4cpp5-dev, libopus-dev, libprotobuf-dev, protobuf-compiler, pkg-config")
SET(CPACK_GENERATOR "DEB")

INCLUDE(CPack)



