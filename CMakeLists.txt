cmake_minimum_required(VERSION 3.30)

project(Multiplayer_Graphic_Games)

# Définit la version de C++
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#Ajoute vcpkg.cmake pour dépendances
set(CMAKE_TOOLCHAIN_FILE "/Users/yoyotaa/vcpkg-master/scripts/buildsystems/vcpkg.cmake" CACHE STRING "vcpkg toolchain file")

# Ajoute les sous-projets
add_subdirectory(client)
add_subdirectory(server)
