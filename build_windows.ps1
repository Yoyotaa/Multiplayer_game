# Variables
$projectRoot = Get-Location
$vcpkgDir = "$projectRoot\vcpkg"
$vcpkgExe = "$vcpkgDir\vcpkg.exe"
$buildDir = "$projectRoot\build"
$triplet = "x64-windows"  # Modifier si nécessaire pour d'autres architectures

# Fonction pour télécharger et initialiser vcpkg
function Install-Vcpkg {
    Write-Host "Téléchargement de vcpkg..."
    git clone https://github.com/microsoft/vcpkg.git $vcpkgDir
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Erreur lors du téléchargement de vcpkg. Vérifiez votre connexion Internet."
        exit 1
    }

    Write-Host "Initialisation de vcpkg..."
    & "$vcpkgDir\bootstrap-vcpkg.bat"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Erreur lors de l'initialisation de vcpkg. Vérifiez les permissions."
        exit 1
    }
}

# Étape 1 : Vérifier si vcpkg est déjà présent
if (!(Test-Path $vcpkgExe)) {
    Install-Vcpkg
} else {
    Write-Host "vcpkg est déjà installé."
}

# Étape 2 : Installer les dépendances nécessaires
Write-Host "Installation des dépendances nécessaires..."
& "$vcpkgExe" install sfml:$triplet --recurse
if ($LASTEXITCODE -ne 0) {
    Write-Error "Erreur lors de l'installation de SFML."
    exit 1
}

& "$vcpkgExe" install boost-asio:$triplet --recurse
if ($LASTEXITCODE -ne 0) {
    Write-Error "Erreur lors de l'installation de Boost.Asio."
    exit 1
}

# Vérifier les dépendances installées
Write-Host "Vérification des dépendances installées..."
& "$vcpkgExe" list
if ($LASTEXITCODE -ne 0) {
    Write-Error "Erreur lors de la vérification des dépendances."
    exit 1
}

# Étape 3 : Nettoyer le répertoire de build
Write-Host "Nettoyage du répertoire de build..."
if (Test-Path $buildDir) {
    Remove-Item -Recurse -Force $buildDir
}
New-Item -ItemType Directory -Path $buildDir | Out-Null

# Étape 4 : Configurer le projet avec CMake
# Configurer le projet avec CMake
Write-Host "Configuration du projet avec CMake..."
Set-Location $buildDir
cmake .. -DCMAKE_TOOLCHAIN_FILE="$vcpkgDir\scripts\buildsystems\vcpkg.cmake" `
         -DVCPKG_TARGET_TRIPLET=$triplet `
         -DSFML_DIR="$vcpkgDir\installed\$triplet\share\sfml"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Erreur lors de la configuration CMake. Vérifiez les logs pour plus d'informations."
    exit 1
}

# Étape 5 : Compiler le projet
Write-Host "Compilation du projet..."
cmake --build . --config Release
if ($LASTEXITCODE -ne 0) {
    Write-Error "Erreur lors de la compilation du projet."
    exit 1
}

# Retour au répertoire racine
Set-Location $projectRoot

Write-Host "Build terminé avec succès ! Les exécutables sont dans le dossier build."
