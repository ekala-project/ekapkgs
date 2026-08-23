{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  libGL,
  libGLU,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coin";
  version = "4.0.10";

  src = fetchFromGitHub {
    owner = "coin3d";
    repo = "coin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Zymizcj+HeNgvvuuIoIHf03I0suOyWGOBIqvnjx5qyw=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    boost
    libGL
    libGLU
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux xorg.libX11;

  cmakeFlags = [ "-DCOIN_USE_CPACK=OFF" ];

  meta = {
    homepage = "https://github.com/coin3d/coin";
    description = "High-level, retained-mode toolkit for effective 3D graphics development";
    mainProgram = "coin-config";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
