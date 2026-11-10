{
  lib,
  mkKdeDerivation,
  fetchurl,
  pkg-config,
  fuse,
}:
mkKdeDerivation rec {
  pname = "kio-fuse";
  version = "5.1.1";

  src = fetchurl {
    url = "mirror://kde/stable/kio-fuse/kio-fuse-${version}.tar.xz";
    hash = "sha256-rfaqfOBVwJh+cWqTrAHzwKl8EoBCFEPNayHg5x12PRQ=";
  };

  extraNativeBuildInputs = [ pkg-config ];

  extraBuildInputs = [ fuse ];

  meta.license = lib.licenses.gpl3Plus;
}
