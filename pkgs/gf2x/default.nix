{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  autoreconfHook,
  buildPackages,
  optimize ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gf2x";
  version = "1.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "gf2x";
    repo = "gf2x";
    rev = "gf2x-${finalAttrs.version}";
    sha256 = "04g5jg0i4vz46b4w2dvbmahwzi3k6b8g515mfw7im1inc78s14id";
  };

  patches = [
    (fetchpatch {
      name = "gf2x-1.3.0-configure-clang16.patch";
      url = "https://gitlab.inria.fr/gf2x/gf2x/-/commit/a2f0fd388c12ca0b9f4525c6cfbc515418dcbaf8.diff";
      hash = "sha256-Aj2KzWZMR24S04IbPOBPwacCU4rEiB+FFWxtRuF50LA=";
    })
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  doCheck = true;

  configureFlags = lib.optionals (!optimize) [
    "--disable-hardware-specific-code"
  ];

  meta = {
    description = "Routines for fast arithmetic in GF(2)[x]";
    homepage = "https://gitlab.inria.fr/gf2x/gf2x/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
