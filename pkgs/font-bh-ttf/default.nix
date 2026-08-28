{
  lib,
  stdenv,
  fetchurl,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-bh-ttf";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-bh-ttf-${finalAttrs.version}.tar.xz";
    hash = "sha256-haX5DQDEjCsG/RJeqK28i47pdCnjB1CByHEJJu/sOlY=";
  };

  strictDeps = true;
  nativeBuildInputs = [ mkfontscale ];

  meta = {
    description = "Luxi TrueType fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/bh-ttf";
    license = lib.licenses.unfreeRedistributable;
    platforms = lib.platforms.unix;
  };
})
