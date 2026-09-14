{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gettext,
  autoreconfHook,
  gmp,
  mpfr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fplll";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "fplll";
    repo = "fplll";
    rev = finalAttrs.version;
    sha256 = "sha256-WvjXaCnUMioSmLlWmLV673mhRjnF+8DU9MqgUmBgaFQ=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    autoreconfHook
  ];

  buildInputs = [
    gmp
    mpfr
  ];

  meta = {
    description = "Lattice algorithms using floating-point arithmetic";
    homepage = "https://github.com/fplll/fplll";
    changelog = [
      "https://github.com/fplll/fplll/releases/tag/${finalAttrs.version}"
      "https://groups.google.com/forum/#!searchin/fplll-devel/FPLLL$20${finalAttrs.version}"
    ];
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
