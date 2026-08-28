{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  uthash,
  meson,
  ninja,
  pkg-config,
  check,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdicom";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ImagingDataCommons";
    repo = "libdicom";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Z1x6pA4oRDtrf9tRAnpJ0e+mmh6nSCIpQrtQGSyxFak=";
  };

  buildInputs = [ uthash ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ]
  ++ lib.optionals (finalAttrs.finalPackage.doCheck) [ check ];

  mesonBuildType = "release";

  mesonFlags = lib.optionals (!finalAttrs.finalPackage.doCheck) [ "-Dtests=false" ];

  doCheck = true;

  meta = {
    description = "C library for reading DICOM files";
    homepage = "https://github.com/ImagingDataCommons/libdicom";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
