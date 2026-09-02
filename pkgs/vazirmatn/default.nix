{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vazirmatn";
  version = "33.003";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "vazirmatn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C1UtfrRFzz0uv/hj8e7huXe4sNd5h7ozVhirWEAyXGg=";
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
    install -Dm644 -t $out/share/fonts/woff2/ fonts/webfonts/*.woff2 2>/dev/null || true
    install -Dm644 -t $out/share/fonts/variable/ fonts/variable/*.ttf 2>/dev/null || true

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/rastikerdar/vazirmatn";
    description = "Persian (Farsi) Font";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
