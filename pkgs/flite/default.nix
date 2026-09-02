{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  alsa-lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flite";
  version = "2.2";

  outputs = [
    "bin"
    "dev"
    "lib"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "festvox";
    repo = "flite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Tq5pyg3TiQt8CPqGXTyLOaGgaeLTmPp+Duw3+2VAF9g=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/festvox/flite/commit/54c65164840777326bbb83517568e38a128122ef.patch";
      hash = "sha256-hvKzdX7adiqd9D+9DbnfNdqEULg1Hhqe1xElYxNM1B8=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/0d316feccaf89c1bd804d6001274426a7135c93a/audio/flite/files/patch-configure";
      hash = "sha256-D2wOtmHFcuA8JRtIds03yPrBGtMuhLJHuufEQdpcB58=";
      extraPrefix = "";
    })
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isLinux alsa-lib;

  configureFlags = [
    "--enable-shared"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ "--with-audio=alsa" ];

  enableParallelBuilding = false;

  meta = {
    description = "Small, fast run-time speech synthesis engine";
    homepage = "http://www.festvox.org/flite/";
    license = lib.licenses.bsdOriginal;
    mainProgram = "flite";
  };
})
