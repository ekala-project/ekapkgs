{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "courier-prime";
  version = "0-unstable-2019-11-20";

  src = fetchFromGitHub {
    owner = "quoteunquoteapps";
    repo = "CourierPrime";
    rev = "7f6d46a766acd9391d899090de467c53fd9c9cb0";
    hash = "sha256-pMFZpytNtgoZrBj2Gj8SgJ0Lab8uVY5aQtcO2lFbHj4=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/truetype/ fonts/ttf/*.ttf

    runHook postInstall
  '';

  meta = {
    description = "Monospaced font designed specifically for screenplays";
    homepage = "https://github.com/quoteunquoteapps/CourierPrime";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
