{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  enableSIMD ? stdenv.hostPlatform.avx2Support,
  enableSSL ? true,
  enableInterop ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glaze";
  version = "7.8.0";

  src = fetchFromGitHub {
    owner = "stephenberry";
    repo = "glaze";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E906rvJh6URPvtsLmOjvNKZQtI52ItkoXQvISIQlNXE=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];
  propagatedBuildInputs = lib.optionals enableSSL [ openssl ];

  cmakeFlags = [
    (lib.cmakeBool "glaze_DISABLE_SIMD_WHEN_SUPPORTED" (!enableSIMD))
    (lib.cmakeBool "glaze_ENABLE_SSL" enableSSL)
    (lib.cmakeBool "glaze_BUILD_INTEROP" enableInterop)
  ];

  meta = {
    homepage = "https://stephenberry.github.io/glaze/";
    changelog = "https://github.com/stephenberry/glaze/releases/tag/v${finalAttrs.version}";
    description = "Extremely fast, in memory, JSON and interface library for modern C++";
    platforms = lib.platforms.all;
    maintainers = [ ];
    license = lib.licenses.mit;
  };
})
