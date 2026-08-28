{
  lib,
  stdenv,
  fetchFromGitHub,
  xz,
}:

stdenv.mkDerivation {
  pname = "pxz";
  version = "4.999.9beta";

  src = fetchFromGitHub {
    owner = "jnovy";
    repo = "pxz";
    rev = "124382a6d0832b13b7c091f72264f8f3f463070a";
    hash = "sha256-NYhPujm5A0j810IKUZEHru/oLXCW7xZf5FjjKAbatZY=";
  };

  patches = [ ./flush-stdout-help-version.patch ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace '`date +%Y%m%d`' '19700101'

    substituteInPlace pxz.c \
      --replace 'XZ_BINARY "xz"' 'XZ_BINARY "${lib.getBin xz}/bin/xz"'
  '';

  buildInputs = [ xz ];

  makeFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man"
  ];

  meta = {
    homepage = "https://jnovy.fedorapeople.org/pxz/";
    license = lib.licenses.gpl2Plus;
    description = "Compression utility that runs LZMA compression of different parts on multiple cores simultaneously";
    mainProgram = "pxz";
    platforms = lib.platforms.linux;
  };
}
