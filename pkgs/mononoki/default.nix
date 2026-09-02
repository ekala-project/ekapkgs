{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mononoki";
  version = "1.6";

  src = fetchzip {
    url = "https://github.com/madmalik/mononoki/releases/download/${finalAttrs.version}/mononoki.zip";
    stripRoot = false;
    hash = "sha256-HQM9rzIJXLOScPEXZu0MzRlblLfbVVNJ+YvpONxXuwQ=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/truetype/ *.ttf

    runHook postInstall
  '';

  meta = {
    description = "Font for programming and code review";
    homepage = "https://github.com/madmalik/mononoki";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
