{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  perl,
  afflib,
  libewf,
  openssl,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sleuthkit";
  version = "4.14.0";

  src = fetchFromGitHub {
    owner = "sleuthkit";
    repo = "sleuthkit";
    rev = "sleuthkit-${finalAttrs.version}";
    hash = "sha256-WvGVEDuhpmcyPOaihDruBbQbcj7s+Zkt2/D5CIsu0u8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/sleuthkit/sleuthkit/commit/8d710c36a947a2666bbef689155831d76fff56b9.patch";
      hash = "sha256-/mCal0EVTM2dM5ok3OmAXQ1HiaCUi0lmhavIuwxVEMA=";
    })
    (fetchpatch {
      url = "https://github.com/sleuthkit/sleuthkit/commit/f78bd37db6be72f8f4d444d124be4e26488dce4b.patch";
      hash = "sha256-ZEeN0jp5cRi6dOpWlcGYm0nLLu5b56ivdR+WrhnhCz0=";
    })
  ];

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
    maintainers = [ ];
    platforms = lib.platforms.unix;
    license = lib.licenses.ipl10;
  };
})
