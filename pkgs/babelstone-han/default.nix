{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "babelstone-han";
  version = "16.0.3";

  src = fetchzip {
    url = "https://babelstone.co.uk/Fonts/Download/BabelStoneHan-${finalAttrs.version}.zip";
    hash = "sha256-HmmRJLs51hoHoKQYdjbiivnJl+RhcBwzkng+5PoqX10=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/truetype/ *.ttf 2>/dev/null || true
    install -Dm644 -t $out/share/fonts/opentype/ *.otf 2>/dev/null || true

    runHook postInstall
  '';

  meta = {
    description = "Unicode CJK font with over 36000 Han characters";
    homepage = "https://www.babelstone.co.uk/Fonts/Han.html";
    license = lib.licenses.arphicpl;
    platforms = lib.platforms.all;
  };
})
