{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  pkg-config,
  popt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "efivar";
  version = "39";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "rhboot";
    repo = "efivar";
    rev = finalAttrs.version;
    hash = "sha256-s/1k5a3n33iLmSpKQT5u08xoj8ypjf2Vzln88OBrqf0=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [ popt ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  # mandoc is not available, skip building docs
  postPatch = ''
    substituteInPlace Makefile --replace-fail "docs" ""
  '';

  makeFlags = [
    "prefix=$(out)"
    "libdir=$(out)/lib"
    "bindir=$(bin)/bin"
    "includedir=$(dev)/include"
    "PCDIR=$(dev)/lib/pkgconfig"
  ];

  meta = {
    description = "Tools and library to manipulate EFI variables";
    homepage = "https://github.com/rhboot/efivar";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21Only;
  };
})
