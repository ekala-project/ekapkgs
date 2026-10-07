{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  texinfo,
  ncurses,
  libxcrypt,
  pam,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "screen";
  version = "5.0.2";

  src = fetchurl {
    url = "mirror://gnu/screen/screen-${finalAttrs.version}.tar.gz";
    hash = "sha256-yposfiQJGbx6wSEkWTrkUpu0619zSdiFeCm34/CzszI=";
  };

  configureFlags = [
    "--enable-telnet"
    "--enable-pam"
  ];

  env.NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE=1";

  nativeBuildInputs = [
    autoreconfHook
    texinfo
  ];

  buildInputs = [
    ncurses
    libxcrypt
    pam
  ];

  outputs = [
    "out"
    "info"
    "man"
  ];

  meta = {
    homepage = "https://www.gnu.org/software/screen/";
    description = "Window manager that multiplexes a physical terminal";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
