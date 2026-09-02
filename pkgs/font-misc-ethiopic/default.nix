{
  lib,
  stdenv,
  fetchurl,
  mkfontscale,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-misc-ethiopic";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-misc-ethiopic-${finalAttrs.version}.tar.xz";
    hash = "sha256-R0mn5uGh7vbJH8yaBOixwO0CfUDBWZ5abJMnDYRpthI=";
  };

  strictDeps = true;

  nativeBuildInputs = [ mkfontscale ];

  meta = {
    description = "Ge'ez Frontiers Foundation's Zemen OpenType and TrueType fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/misc-ethiopic";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
