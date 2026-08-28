{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "public-sans";
  version = "2.001";

  src = fetchzip {
    url = "https://github.com/uswds/public-sans/releases/download/v${finalAttrs.version}/public-sans-v${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-XFs/UMXI/kdrW+53t8Mj26+Rn5p+LQ6KW2K2/ShoIag=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/truetype/ fonts/ttf/*.ttf 2>/dev/null || true
    install -Dm644 -t $out/share/fonts/opentype/ fonts/otf/*.otf 2>/dev/null || true
    install -Dm644 -t $out/share/fonts/woff/ fonts/webfonts/*.woff 2>/dev/null || true
    install -Dm644 -t $out/share/fonts/woff2/ fonts/webfonts/*.woff2 2>/dev/null || true
    install -Dm644 -t $out/share/fonts/variable/ fonts/variable/*.ttf 2>/dev/null || true

    runHook postInstall
  '';

  meta = {
    description = "Strong, neutral, principles-driven, open source typeface for text or display";
    homepage = "https://public-sans.digital.gov/";
    changelog = "https://github.com/uswds/public-sans/raw/v${finalAttrs.version}/FONTLOG.txt";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
