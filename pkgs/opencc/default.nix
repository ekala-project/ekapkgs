{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  rapidjson,
}:

stdenv.mkDerivation rec {
  pname = "opencc";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "BYVoid";
    repo = "OpenCC";
    rev = "ver.${version}";
    sha256 = "sha256-FgpAnN9bo2H6cuLEuxxSg5I4R0zViDrJ8KueNEoTVF8=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    python3
  ];

  buildInputs = [
    rapidjson
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_RAPIDJSON" true)
  ];

  meta = {
    homepage = "https://github.com/BYVoid/OpenCC";
    license = lib.licenses.asl20;
    description = "Project for conversion between Traditional and Simplified Chinese";
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
