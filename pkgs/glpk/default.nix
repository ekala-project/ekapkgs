{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  fetchDebianPatch,
  gmp,
}:

stdenv.mkDerivation rec {
  pname = "glpk";
  version = "5.0";

  src = fetchurl {
    url = "mirror://gnu/glpk/glpk-${version}.tar.gz";
    sha256 = "sha256-ShAT7rtQ9yj8YBvdgzsLKHAzPDs+WoFu66kh2VvsbxU=";
  };

  buildInputs = [
    gmp
  ];

  configureFlags = [
    "--with-gmp"
  ];

  patches = [
    (fetchpatch {
      name = "error_recovery.patch";
      url = "https://raw.githubusercontent.com/sagemath/sage/d3c1f607e32f964bf0cab877a63767c86fd00266/build/pkgs/glpk/patches/error_recovery.patch";
      sha256 = "sha256-2hNtUEoGTFt3JgUvLH3tPWnz+DZcXNhjXzS+/V89toA=";
    })

    (fetchDebianPatch {
      inherit pname version;
      debianRevision = "2";
      patch = "gcc-15.patch";
      hash = "sha256-wuWPYqJKIKJAJaeJXW7lhvapu8Fd3zHjLAv7Ve7q8Qw=";
    })
  ];

  meta = {
    description = "GNU Linear Programming Kit";
    homepage = "https://www.gnu.org/software/glpk/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "glpsol";
    platforms = lib.platforms.all;
  };
}
