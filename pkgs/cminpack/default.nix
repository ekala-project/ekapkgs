{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  withBlas ? false,
  blas,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cminpack";
  version = "1.3.11";

  src = fetchFromGitHub {
    owner = "devernay";
    repo = "cminpack";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GF9HiITX/XV8hXrp5lJw2XM0Zyb/CBkMZkRFBbQj03A=";
  };

  postPatch = ''
    substituteInPlace cmake/cminpack.pc.in \
      --replace-fail ''\'''${prefix}/' ""
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = lib.optionals withBlas [
    blas
  ];

  cmakeFlags = [
    "-DUSE_BLAS=${if withBlas then "ON" else "OFF"}"
    "-DBUILD_SHARED_LIBS=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
  ];

  meta = {
    description = "Software for solving nonlinear equations and nonlinear least squares problems";
    homepage = "http://devernay.free.fr/hacks/cminpack/";
    changelog = "https://github.com/devernay/cminpack/blob/v${finalAttrs.version}/README.md#history";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
