# Utiliser une image Windows avec Visual Studio
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Installer les outils nécessaires
RUN apt-get update && apt-get install -y cmake git

# Installer vcpkg
WORKDIR /vcpkg
RUN git clone https://github.com/microsoft/vcpkg.git .
RUN ./bootstrap-vcpkg.sh

# Copier les fichiers du projet
WORKDIR /app
COPY . .

# Configurer et compiler avec CMake
RUN cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=/vcpkg/scripts/buildsystems/vcpkg.cmake -DVCPKG_TARGET_TRIPLET=x64-windows
RUN cmake --build build --config Release
