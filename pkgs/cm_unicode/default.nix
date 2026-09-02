{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cm-unicode";
  version = "0.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/cm-unicode/cm-unicode/${finalAttrs.version}/cm-unicode-${finalAttrs.version}-otf.tar.xz";
    hash = "sha256-VIp+vk1IYbEHW15wMrfGVOPqg1zBZDpgFx+jlypOHCg=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/opentype/ *.otf
    install -Dm644 -t $out/share/doc/cm-unicode-${finalAttrs.version} README FontLog.txt

    runHook postInstall
  '';

  meta = {
    homepage = "https://cm-unicode.sourceforge.io/";
    description = "Computer Modern Unicode fonts";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
