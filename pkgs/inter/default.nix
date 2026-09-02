{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "inter";
  version = "4.1";

  src = fetchzip {
    url = "https://github.com/rsms/inter/releases/download/v${version}/Inter-${version}.zip";
    stripRoot = false;
    hash = "sha256-5vdKKvHAeZi6igrfpbOdhZlDX2/5+UvzlnCQV6DdqoQ=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    rm -rf extras/
    install -Dm644 -t $out/share/fonts/opentype/ *.otf || true
    install -Dm644 -t $out/share/fonts/truetype/ *.ttf || true

    runHook postInstall
  '';

  meta = {
    homepage = "https://rsms.me/inter/";
    description = "Typeface specially designed for user interfaces";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
