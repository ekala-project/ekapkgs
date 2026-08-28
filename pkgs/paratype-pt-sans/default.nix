{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "paratype-pt-sans";
  version = "2.003";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "a4f3deeca2d7547351ff746f7bf3b51f5528dbcf";
    hash = "sha256-o766Pcq/eOyC96TRTRqxBPxiszufhPaZJHtRyDYj0oQ=";
    rootDir = "ofl/ptsans";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    find . -name '*.ttf' -exec install -Dm644 -t $out/share/fonts/truetype/ {} +

    runHook postInstall
  '';

  meta = {
    description = "Open Paratype font";
    homepage = "https://www.paratype.ru/catalog/font/pt/pt-sans";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
