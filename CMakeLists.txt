cmake_minimum_required(VERSION 3.30)

set(CMAKE_TOOLCHAIN_FILE "/Users/yoyotaa/vcpkg-master/scripts/buildsystems/vcpkg.cmake" CACHE STRING "vcpkg toolchain file")

project(Multiplayer_Graphic_Games)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Repo vcpkg
find_package(SFML COMPONENTS system network window graphics audio CONFIG REQUIRED)

add_executable(Multiplayer_Graphic_Games main.cpp)

target_link_libraries(Multiplayer_Graphic_Games PRIVATE sfml-system sfml-network sfml-graphics sfml-window sfml-audio)
