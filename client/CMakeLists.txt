cmake_minimum_required(VERSION 3.30)

project(Ienclit_game)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Repo vcpkg
find_package(SFML COMPONENTS system network window graphics audio CONFIG REQUIRED)

add_executable(Ienclit_game sources/main.cpp)

target_link_libraries(Ienclit_game PRIVATE sfml-system sfml-network sfml-graphics sfml-window sfml-audio)
