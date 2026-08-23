{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "alkalami";
  version = "3.000";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/alkalami/Alkalami-${finalAttrs.version}.zip";
    hash = "sha256-ra664VbUKc8XpULCWhLMVnc1mW4pqZvbvwuBvRQRhcY=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/truetype/ *.ttf
    install -Dm644 -t $out/share/fonts/opentype/ *.otf 2>/dev/null || true
    install -Dm644 -t $out/share/fonts/woff/ web/*.woff 2>/dev/null || true
    install -Dm644 -t $out/share/fonts/woff2/ web/*.woff2 2>/dev/null || true
    mkdir -p $out/share/doc/alkalami
    mv *.txt documentation $out/share/doc/alkalami 2>/dev/null || true

    runHook postInstall
  '';

  meta = {
    homepage = "https://software.sil.org/alkalami/";
    description = "Font for Arabic-based writing systems in the Kano region of Nigeria and in Niger";
    license = lib.licenses.ofl;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
