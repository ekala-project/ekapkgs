{
  lib,
  stdenv,
  fetchurl,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-ibm-type1";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-ibm-type1-${finalAttrs.version}.tar.xz";
    hash = "sha256-xDlelbpG1AxK0XN+kcrCDAq3VBEym2DbXZn+2Stgzn8=";
  };

  strictDeps = true;

  nativeBuildInputs = [ mkfontscale ];

  meta = {
    description = "IBM Courier Type1 fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/ibm-type1";
    license = lib.licenses.unfreeRedistributable;
    platforms = lib.platforms.unix;
  };
})
