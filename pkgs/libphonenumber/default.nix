{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  jdk,
  pkg-config,
  boost,
  icu,
  protobuf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libphonenumber";
  version = "9.0.5";

  src = fetchFromGitHub {
    owner = "google";
    repo = "libphonenumber";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CVT0HBT4WnlTrT8mhapJjyIbd+pp7uxrZxa9ZlXVm3c=";
  };

  patches = [
    ./build-reproducibility.patch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    gtest
    jdk
    pkg-config
  ];

  buildInputs = [
    boost
    icu
    protobuf
  ];

  cmakeDir = "../cpp";

  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  doCheck = true;

  checkTarget = "tests";

  meta = with lib; {
    description = "Google's i18n library for parsing and using phone numbers";
    homepage = "https://github.com/google/libphonenumber";
    license = licenses.asl20;
  };
})
