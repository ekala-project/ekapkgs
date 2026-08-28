{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hdrhistogram_c";
  version = "0.11.10";

  src = fetchFromGitHub {
    owner = "HdrHistogram";
    repo = "HdrHistogram_c";
    tag = finalAttrs.version;
    hash = "sha256-LMZj7vuxOA1bgU/J10IKnyNe3R0dk2AA1ydLTHun4vg=";
  };

  # Fix build on i686 by not trying to build AVX2 code
  # Submitted upstream: https://github.com/HdrHistogram/HdrHistogram_c/pull/143
  ${if stdenv.hostPlatform.isi686 then "patches" else null} = [
    ./no-avx2-i386.patch
  ];

  buildInputs = [ zlib ];
  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    validatePkgConfig
  ];

  doCheck = true;

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
  };

  meta = {
    description = "C port or High Dynamic Range (HDR) Histogram";
    homepage = "https://github.com/HdrHistogram/HdrHistogram_c";
    changelog = "https://github.com/HdrHistogram/HdrHistogram_c/releases/tag/${finalAttrs.version}";
    license = lib.licenses.publicDomain;
    pkgConfigModules = [ "hdr_histogram" ];
  };
})
