{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sqlite,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sqlitecpp";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "SRombauts";
    repo = "sqlitecpp";
    rev = finalAttrs.version;
    hash = "sha256-lmXvh2z+6QLLUapsHouBuAxgBQwbC5XKq80sza6CaUI=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];
  buildInputs = [
    sqlite
    gtest
  ];
  doCheck = true;

  cmakeEntries = {
    SQLITECPP_INTERNAL_SQLITE = false;
    SQLITECPP_BUILD_TESTS = true;
  };

  meta = {
    homepage = "https://srombauts.github.io/SQLiteCpp/";
    description = "C++ SQLite3 wrapper";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
