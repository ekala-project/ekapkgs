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
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "BYVoid";
    repo = "OpenCC";
    rev = "ver.${version}";
    sha256 = "sha256-JBTegQs9ALp4LdKKYMNp9GYEgqR9O8IkX6LqatvaTic=";
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
