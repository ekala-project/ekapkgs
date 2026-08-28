{
  lib,
  stdenv,
  fetchurl,
  which,
  autoconf,
  automake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-common";
  version = "3.18.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-common/${lib.versions.majorMinor finalAttrs.version}/gnome-common-${finalAttrs.version}.tar.xz";
    hash = "sha256-IlaeNwrnVeBFJ7djKL78THO2K/1KVySZ/eEWuDGK+M8=";
  };

  propagatedBuildInputs = [
    which
    autoconf
    automake
  ];

  meta = {
    description = "Common GNOME build infrastructure";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
