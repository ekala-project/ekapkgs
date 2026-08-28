{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
  withTarget ? "GENERIC",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blasfeo";
  version = "0.1.4.3";

  src = fetchFromGitHub {
    owner = "giaf";
    repo = "blasfeo";
    rev = finalAttrs.version;
    hash = "sha256-+hdS/HGw49pSKOOL4jzAhScVGIFTsEqYwXSpQi3GBm0=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [ "-DTARGET=${withTarget}" ];

  meta = {
    description = "Basic linear algebra subroutines for embedded optimization";
    homepage = "https://github.com/giaf/blasfeo";
    changelog = "https://github.com/giaf/blasfeo/blob/${finalAttrs.version}/Changelog.txt";
    license = lib.licenses.bsd2;
  };
})
