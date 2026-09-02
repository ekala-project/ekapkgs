{
  lib,
  stdenv,
  fetchurl,
  mkfontscale,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-adobe-utopia-type1";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-adobe-utopia-type1-${finalAttrs.version}.tar.xz";
    hash = "sha256-TLKAvEdpOwfF4A/Q5a1XIaq+vAVIw/BndOXMPLz3Vpc=";
  };

  strictDeps = true;
  nativeBuildInputs = [ mkfontscale ];

  meta = {
    description = "Adobe Utopia PostScript Type 1 fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/adobe-utopia-type1";
    license = lib.licenses.adobeUtopia;
    platforms = lib.platforms.unix;
  };
})
