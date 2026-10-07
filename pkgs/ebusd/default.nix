{
  lib,
  stdenv,
  pkgs,
  fetchFromGitHub,
  fetchpatch,
  argparse,
  mosquitto,
  cmake,
  autoconf,
  automake,
  libtool,
  pkg-config,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "ebusd";
  version = "26.1";

  src = fetchFromGitHub {
    owner = "john30";
    repo = "ebusd";
    rev = version;
    sha256 = "sha256-CmArhkJfxf8lL6FoHRQKjk/8ObfEy3Xef9DUtOVKRas=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    autoconf
    automake
    libtool
    pkg-config
  ];

  buildInputs = [
    argparse
    mosquitto
    openssl
  ];

  patches = [
    ./patches/ebusd-cmake.patch
  ];

  preInstall = ''
    mkdir -p $out/usr/bin
  '';

  cmakeEntries = {
    CMAKE_INSTALL_SYSCONFDIR = "${placeholder ";
    CMAKE_INSTALL_BINDIR = "${placeholder ";
    CMAKE_INSTALL_LOCALSTATEDIR = "${placeholder ";
  };

  cmakeFlags = [
    out"}/etc"
    out"}/bin"
    TMPDIR"}"
  ];

  postInstall = ''
    rmdir $out/usr/bin
    rmdir $out/usr
  '';

  meta = {
    description = "ebusd";
    homepage = "https://github.com/john30/ebusd";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
