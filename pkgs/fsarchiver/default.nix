{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  zlib,
  bzip2,
  lzo,
  lz4,
  zstd,
  xz,
  libgcrypt,
  e2fsprogs,
  util-linux,
  libgpg-error,
}:

stdenv.mkDerivation {
  pname = "fsarchiver";
  version = "0.8.9";

  src = fetchFromGitHub {
    owner = "fdupoux";
    repo = "fsarchiver";
    rev = "0.8.9";
    sha256 = "sha256-eJ+25wfOZ7qYL5zi2kz0+03xg6gnKmLG+xjC7wEJ2HM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    zlib
    bzip2
    xz
    lzo
    lz4
    zstd
    libgcrypt
    e2fsprogs
    util-linux
    libgpg-error
  ];

  meta = {
    description = "File system archiver for linux";
    homepage = "https://www.fsarchiver.org/";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.linux;
    mainProgram = "fsarchiver";
  };
}
