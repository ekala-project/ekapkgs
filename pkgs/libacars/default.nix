{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libacars";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "szpajder";
    repo = "libacars";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nArUiGVxQFkyoZ2dECBift8yeFJOKJeVHU1FnKrJpYs=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = {
    homepage = "https://github.com/szpajder/libacars";
    description = "Aircraft Communications Addressing and Reporting System (ACARS) message decoder";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
