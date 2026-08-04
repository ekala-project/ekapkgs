{
  lib,
  stdenv,
  fetchurl,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-misc-meltho";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-misc-meltho-${finalAttrs.version}.tar.xz";
    hash = "sha256-Y75ewXB4iY8mPCQJami0OuWwa4iFLkJUmvoD0STWUhk=";
  };

  strictDeps = true;

  nativeBuildInputs = [ mkfontscale ];
  meta = {
    description = "Collection of otf fonts designed for the display of syriac text";
    homepage = "https://gitlab.freedesktop.org/xorg/font/misc-meltho";
    # modified Bigelow & Holmes Font License
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
