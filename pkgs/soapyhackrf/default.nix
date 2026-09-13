{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  hackrf,
  soapysdr,
}:

stdenv.mkDerivation {
  pname = "soapyhackrf";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyHackRF";
    rev = "soapy-hackrf-0.3.4";
    sha256 = "sha256-fzPYHJAPX8FkFxPXpLlUagTd/NoamRX0YnxHwkbV1nI=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    hackrf
    soapysdr
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/pothosware/SoapyHackRF/commit/143ff5e7e0f786e341df8846c04e8273c5183c26.patch";
      hash = "sha256-8tMN6uEWUt1sUC45kBM6WHXDd/oTFyo6u+NpVPg+z5Q=";
    })
  ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = {
    homepage = "https://github.com/pothosware/SoapyHackRF";
    description = "SoapySDR plugin for HackRF devices";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
