{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "unicode-cldr-common";
  version = "46.1";

  src = fetchurl {
    url = "https://unicode.org/Public/cldr/${finalAttrs.version}/cldr-common-${finalAttrs.version}.zip";
    hash = "sha256-w4KMkoDGs7uSG8lrr1O+IXS1QW1y50DsORXB/5GlCoA=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/unicode/cldr
    cp -r common $out/share/unicode/cldr/

    runHook postInstall
  '';

  meta = {
    description = "Unicode Common Locale Data Repository (CLDR) annotation data";
    homepage = "https://cldr.unicode.org/";
    license = lib.licenses.unicode-dfs-2016;
    platforms = lib.platforms.all;
  };
})
