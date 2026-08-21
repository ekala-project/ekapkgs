{
  lib,
  stdenv,
  fetchurl,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-bh-type1";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-bh-type1-${finalAttrs.version}.tar.xz";
    hash = "sha256-Gd7D7Aar3mvt0QCUV56Si+Dw/DvbT76T9MaczkBtcqY=";
  };

  strictDeps = true;
  nativeBuildInputs = [ mkfontscale ];
  meta = {
    description = "Luxi PostScript Type 1 fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/bh-type1";
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
