{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "libutp";
  version = "unstable-2017-01-02";

  src = fetchFromGitHub {
    owner = "transmission";
    repo = pname;
    rev = "fda9f4b3db97ccb243fcbed2ce280eb4135d705b";
    sha256 = "CvuZLOBksIl/lS6LaqOIuzNvX3ihlIPjI3Eqwo7YJH0=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "uTorrent Transport Protocol library";
    homepage = "https://github.com/transmission/libutp";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
