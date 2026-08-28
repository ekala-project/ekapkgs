{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "biz-ud-gothic";
  version = "1.051";

  src = fetchzip {
    url = "https://github.com/googlefonts/morisawa-biz-ud-gothic/releases/download/v${finalAttrs.version}/morisawa-biz-ud-gothic-fonts.zip";
    hash = "sha256-7PlIrQX1fnFHXm7mjfoOCVp3GSnLT2GlVZdSoZbh/s4=";
  };

  sourceRoot = "${finalAttrs.src.name}/fonts";

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/truetype/ ttf/*.ttf

    runHook postInstall
  '';

  meta = {
    description = "Universal Design Japanese font";
    homepage = "https://github.com/googlefonts/morisawa-biz-ud-gothic";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
