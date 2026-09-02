{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  perl,
  afflib,
  libewf,
  openssl,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sleuthkit";
  version = "4.15.0";

  src = fetchFromGitHub {
    owner = "sleuthkit";
    repo = "sleuthkit";
    rev = "sleuthkit-${finalAttrs.version}";
    hash = "sha256-11KK7O7V8bMp0YMt9ZPwAJ00n0VeXMooYTbu+By6b2Q=";
  };

  postPatch = ''
    substituteInPlace tsk/img/ewf.cpp --replace libewf_handle_read_random libewf_handle_read_buffer_at_offset
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    perl
  ];

  buildInputs = [
    afflib
    libewf
    openssl
    zlib
  ];

  configureFlags = [
    "--disable-java"
  ];

  # Hack to fix the RPATH
  preFixup = ''
    rm -rf */.libs
  '';

  meta = {
    description = "Forensic/data recovery tool";
    homepage = "https://www.sleuthkit.org/";
    changelog = "https://github.com/sleuthkit/sleuthkit/blob/${finalAttrs.src.rev}/NEWS.txt";
    platforms = lib.platforms.unix;
    license = lib.licenses.ipl10;
  };
})
