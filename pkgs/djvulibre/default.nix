{
  lib,
  stdenv,
  fetchurl,
  libjpeg,
  libtiff,
  librsvg,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "djvulibre";
  version = "3.5.28";

  src = fetchurl {
    url = "mirror://sourceforge/djvu/${pname}-${version}.tar.gz";
    sha256 = "1p1fiygq9ny8aimwc4vxwjc6k9ykgdsq1sq06slfbzalfvm0kl7w";
  };

  outputs = [
    "bin"
    "out"
    "dev"
    "lib"
    "man"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    librsvg
  ];

  buildInputs = [
    libjpeg
    libtiff
    bash
  ];

  enableParallelBuilding = true;

  patches = [
    ./c++17-register-class.patch
    ./CVE-2021-3500+CVE-2021-32490+CVE-2021-32491+CVE-2021-32492+CVE-2021-32493.patch
  ];

  meta = {
    description = "Big set of CLI tools to make/modify/optimize/show/export DJVU files";
    homepage = "https://djvu.sourceforge.net";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
}
