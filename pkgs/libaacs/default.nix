{
  lib,
  stdenv,
  fetchurl,
  libgcrypt,
  libgpg-error,
  bison,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libaacs";
  version = "0.11.1";

  src = fetchurl {
    url = "https://get.videolan.org/libaacs/${finalAttrs.version}/libaacs-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-qIqg6+TJinf3rv/ZKrPvZKxUjGuCLoJIqLkmclvqCjk=";
  };

  buildInputs = [
    libgcrypt
    libgpg-error
  ];

  nativeBuildInputs = [
    bison
    flex
  ];

  meta = {
    homepage = "https://www.videolan.org/developers/libaacs.html";
    description = "Library to access AACS protected Blu-Ray disks";
    mainProgram = "aacs_info";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
  };
})
