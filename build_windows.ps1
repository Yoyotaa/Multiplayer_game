# Script PowerShell pour configurer et compiler un projet avec vcpkg

# Définir des variables de base
$projectRoot = Get-Location
$vcpkgDir = "$projectRoot\vcpkg"
$vcpkgExe = "$vcpkgDir\vcpkg.exe"
$buildDir = "$projectRoot\build"
$triplet = "x64-windows"  # Modifier si nécessaire pour d'autres architectures

# Fonction pour télécharger et installer vcpkg
function Install-Vcpkg {
    Write-Host "Téléchargement de vcpkg..."
    git clone https://github.com/microsoft/vcpkg.git $vcpkgDir
    Write-Host "Initialisation de vcpkg..."
    & "$vcpkgDir\bootstrap-vcpkg.bat"
}

# Vérifier si vcpkg est déjà présent
if (!(Test-Path $vcpkgExe)) {
    Install-Vcpkg
} else {
    Write-Host "vcpkg est déjà installé."
}

# Installer les dépendances nécessaires
Write-Host "Installation des dépendances nécessaires..."
& "$vcpkgExe" install sfml:$triplet
& "$vcpkgExe" install boost-asio:$triplet

# Créer le dossier de build si nécessaire
if (!(Test-Path $buildDir)) {
    New-Item -ItemType Directory -Path $buildDir
}

# Passer au dossier de build
Set-Location $buildDir

# Lancer CMake pour configurer le projet
Write-Host "Configuration du projet avec CMake..."
cmake .. -DCMAKE_TOOLCHAIN_FILE="$vcpkgDir\scripts\buildsystems\vcpkg.cmake" -DVCPKG_TARGET_TRIPLET=$triplet

# Compiler le projet
Write-Host "Compilation du projet..."
cmake --build . --config Release

# Retour à la racine du projet
Set-Location $projectRoot

Write-Host "Build terminé avec succès ! Les exécutables sont dans le dossier build."
