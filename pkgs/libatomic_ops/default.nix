{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libatomic_ops";
  version = "7.10.0";

  src = fetchurl {
    urls = [
      "http://www.ivmaisoft.com/_bin/atomic_ops/libatomic_ops-${finalAttrs.version}.tar.gz"
      "https://github.com/ivmai/libatomic_ops/releases/download/v${finalAttrs.version}/libatomic_ops-${finalAttrs.version}.tar.gz"
    ];
    sha256 = "sha256-DbPr/3VdsXD2XnSmTsRRGBLp7jGFwjLu/+rNJ0GQ37A=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  meta = {
    description = "Library for semi-portable access to hardware-provided atomic memory update operations";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
