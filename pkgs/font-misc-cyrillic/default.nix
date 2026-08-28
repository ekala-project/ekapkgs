{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-misc-cyrillic";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-misc-cyrillic-${finalAttrs.version}.tar.xz";
    hash = "sha256-dgIaf1MGQAGRSlf9CO+uV/draPCiTcqKsbJFR07o6ZM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bdftopcf
    mkfontscale
  ];

  meta = {
    description = "Misc Cyrillic pcf fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/misc-cyrillic";
    license = with lib.licenses; [
      publicDomain
      cronyx
      # misc free
      # "May be distributed and modified without restrictions."
      free
    ];
    platforms = lib.platforms.unix;
  };
})
