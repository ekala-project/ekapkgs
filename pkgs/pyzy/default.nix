{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  python3,
  glib,
  libuuid,
  sqlite,
}:

stdenv.mkDerivation {
  pname = "pyzy";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "pyzy";
    rev = "5ac51d833777a881e80f0b23d704345cf0feb0d0";
    hash = "sha256-OiFdog34kjmgF2DCnA8LjlZseZPQ8iCYQD4HZKNnCVU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
  ];

  buildInputs = [
    glib
    libuuid
    sqlite
  ];

  postPatch = ''
    patchShebangs ./data/db/android/create_db.py
  '';
  meta = {
    description = "Chinese PinYin and Bopomofo conversion library";
    homepage = "https://github.com/openSUSE/pyzy";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
  };
}
