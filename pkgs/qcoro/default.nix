{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libpthread-stubs,
  qt6,
  qtbase ? qt6.qtbase,
  qtwebsockets,
  wrapQtAppsHook ? qt6.wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "qcoro";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "danvratil";
    repo = "qcoro";
    rev = "v${version}";
    sha256 = "sha256-NF+va2pS2NJt4OE+yfN/jVnfkueBdjoyg2lQJhMRWe4=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
    cmake
  ];

  buildInputs = [
    qtbase
    qtwebsockets
    libpthread-stubs
  ];

  meta = {
    description = "Library for using C++20 coroutines in connection with certain asynchronous Qt actions";
    homepage = "https://github.com/danvratil/qcoro";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
