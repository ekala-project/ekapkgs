{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  autoreconfHook,
  libgpg-error,
  libassuan,
  ncurses,
  libsecret,
}:

stdenv.mkDerivation rec {
  pname = "pinentry-curses";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://gnupg/pinentry/pinentry-${version}.tar.bz2";
    hash = "sha256-jphu2IVhtNpunv4MVPpMqJIwNcmSZN8LBGRJfF+5Tp4=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    libgpg-error
    libassuan
    libsecret
    ncurses
  ];

  patches = [
    ./autoconf-ar.patch
    ./gettext-0.25.patch
  ];

  configureFlags = [
    "--with-libgpg-error-prefix=${libgpg-error.dev}"
    "--with-libassuan-prefix=${libassuan.dev}"
    "--enable-libsecret"
    "--enable-pinentry-curses"
    "--enable-pinentry-tty"
    "--disable-pinentry-gtk2"
    "--disable-pinentry-gnome3"
    "--disable-pinentry-qt5"
    "--disable-pinentry-qt"
    "--disable-pinentry-emacs"
  ];

  meta = {
    homepage = "https://gnupg.org/software/pinentry/index.html";
    description = "GnuPG's interface to passphrase input";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    mainProgram = "pinentry";
  };
}
