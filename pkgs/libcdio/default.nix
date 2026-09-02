{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  texinfo,
  pkg-config,
  ncurses,
  help2man,
  libiconv,
}:

let
  withMan = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libcdio";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "libcdio";
    repo = "libcdio";
    tag = finalAttrs.version;
    hash = "sha256-BzV86qnIOvhTJiNZ54zW1u3oXhDyNMsIKDdfNGBWLes=";
  };

  env = lib.optionalAttrs stdenv.hostPlatform.is32bit {
    NIX_CFLAGS_COMPILE = "-D_LARGEFILE64_SOURCE";
  };

  postPatch = ''
    patchShebangs .
    echo "
    @set UPDATED 1 January 1970
    @set UPDATED-MONTH January 1970
    @set EDITION ${finalAttrs.version}
    @set VERSION ${finalAttrs.version}
    " > doc/version.texi
  ''
  + lib.optionalString (!withMan) ''
    substituteInPlace src/Makefile.am \
      --replace-fail 'man_cd_drive     = cd-drive.1' "" \
      --replace-fail 'man_cd_info     = cd-info.1' "" \
      --replace-fail 'man_cd_read     = cd-read.1' "" \
      --replace-fail 'man_iso_info     = iso-info.1' "" \
      --replace-fail 'man_iso_read     = iso-read.1' ""
  '';

  configureFlags = [
    (lib.enableFeature withMan "maintainer-mode")
    "CFLAGS=-std=gnu17"
  ];

  preConfigure = ''
    export am_cv_func_iconv_works=yes
  '';

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    texinfo
  ]
  ++ lib.optionals withMan [
    help2man
  ];

  buildInputs = [
    libiconv
    ncurses
  ];

  enableParallelBuilding = true;

  doCheck = !stdenv.hostPlatform.isDarwin;

  outputs = [
    "out"
    "lib"
    "dev"
    "info"
  ]
  ++ lib.optionals withMan [
    "man"
  ];

  meta = {
    description = "Library for OS-independent CD-ROM and CD image access";
    homepage = "https://www.gnu.org/software/libcdio/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
