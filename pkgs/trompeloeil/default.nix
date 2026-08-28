{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trompeloeil";
  version = "49";

  src = fetchFromGitHub {
    owner = "rollbear";
    repo = "trompeloeil";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-AyTBHsPYaruq0jadifVqOs80YZ5xwajHdHgMINl3i1Q=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "Header only C++14 mocking framework";
    homepage = "https://github.com/rollbear/trompeloeil";
    license = lib.licenses.boost;
    platforms = lib.platforms.unix;
  };
})
