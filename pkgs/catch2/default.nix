{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "catch2";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "catchorg";
    repo = "Catch2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-blhSdtNXwe4wKPVKlopsE0omgikMdl12JjwqASwJM2w=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  hardeningDisable = [ "trivialautovarinit" ];

  cmakeFlags = [
    "-DCATCH_DEVELOPMENT_BUILD=ON"
    "-DCATCH_BUILD_TESTING=${if finalAttrs.doCheck then "ON" else "OFF"}"
    "-DCATCH_ENABLE_WERROR=OFF"
  ];

  strictDeps = true;

  doCheck = true;

  nativeCheckInputs = [
    python3
  ];

  meta = {
    description = "Modern, C++-native, test framework for unit-tests";
    homepage = "https://github.com/catchorg/Catch2";
    license = lib.licenses.boost;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
