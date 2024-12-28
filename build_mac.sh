#!/bin/bash

# Définir les variables de base
PROJECT_ROOT=$(pwd)
VCPKG_DIR="$PROJECT_ROOT/vcpkg"
VCPKG_EXE="$VCPKG_DIR/vcpkg"
BUILD_DIR="$PROJECT_ROOT/build"
TRIPLET="arm64-osx"  # Pour les Mac Apple Silicon ; utiliser "x64-osx" pour les Mac Intel

# Fonction pour télécharger et configurer vcpkg
install_vcpkg() {
    echo "Téléchargement de vcpkg..."
    git clone https://github.com/microsoft/vcpkg.git "$VCPKG_DIR"
    echo "Initialisation de vcpkg..."
    "$VCPKG_DIR/bootstrap-vcpkg.sh"
}

# Vérifier si vcpkg est déjà présent
if [ ! -f "$VCPKG_EXE" ]; then
    install_vcpkg
else
    echo "vcpkg est déjà installé."
fi

# Installer les dépendances nécessaires
echo "Installation des dépendances nécessaires..."
"$VCPKG_EXE" install sfml:$TRIPLET
"$VCPKG_EXE" install boost-asio:$TRIPLET

# Créer le dossier de build si nécessaire
if [ ! -d "$BUILD_DIR" ]; then
    mkdir "$BUILD_DIR"
fi

# Passer au dossier de build
cd "$BUILD_DIR" || exit

# Lancer CMake pour configurer le projet
echo "Configuration du projet avec CMake..."
cmake .. -DCMAKE_TOOLCHAIN_FILE="$VCPKG_DIR/scripts/buildsystems/vcpkg.cmake" -DVCPKG_TARGET_TRIPLET=$TRIPLET

# Compiler le projet
echo "Compilation du projet..."
cmake --build . --config Release

# Retourner à la racine du projet
cd "$PROJECT_ROOT" || exit

echo "Build terminé avec succès ! Les exécutables sont dans le dossier build."
