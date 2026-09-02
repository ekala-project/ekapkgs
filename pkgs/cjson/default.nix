{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cjson";
  version = "1.7.19";

  src = fetchFromGitHub {
    owner = "DaveGamble";
    repo = "cJSON";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-WjgzokT9aHJ7dB40BtmhS7ur1slTuXmemgDimZHLVQM=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail -std=c89 -std=c99
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required(VERSION 3.0)' \
        'cmake_minimum_required(VERSION 3.10)'
  '';

  meta = {
    homepage = "https://github.com/DaveGamble/cJSON";
    description = "Ultralightweight JSON parser in ANSI C";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
