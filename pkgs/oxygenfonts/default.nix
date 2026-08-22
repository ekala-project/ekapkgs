{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "oxygenfonts";
  version = "5.4.3";

  src = fetchzip {
    url = "https://invent.kde.org/unmaintained/oxygen-fonts/-/archive/v${finalAttrs.version}/oxygen-fonts-v${finalAttrs.version}.zip";
    hash = "sha256-N8fU5/iqgtFqaqdGuqbEVDsFCmVcHXLodo/T5NZMu8U=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Desktop/gui font for integrated use with the KDE desktop";
    homepage = "https://github.com/vernnobile/oxygenFont";
    license = lib.licenses.ofl;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
