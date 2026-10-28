{
  lib,
  stdenv,
  fetchurl,
  perl,
  librsvg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "icon-naming-utils";
  version = "0.8.90";

  src = fetchurl {
    url = "https://tango.freedesktop.org/releases/icon-naming-utils-${finalAttrs.version}.tar.gz";
    sha256 = "071fj2jm5kydlz02ic5sylhmw6h2p3cgrm3gwdfabinqkqcv4jh4";
  };

  nativeBuildInputs = [
    (perl.withPackages (p: [ p.XMLSimple ]))
  ];

  buildInputs = [
    librsvg
  ];

  strictDeps = true;

  meta = {
    description = "Script for maintaining backwards-compatibility of Tango icon naming";
    homepage = "https://tango.freedesktop.org/Standard_Icon_Naming_Specification";
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; linux ++ darwin;
  };
})
