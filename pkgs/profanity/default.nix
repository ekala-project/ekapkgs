{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  cmocka ? null,
  curl,
  expat,
  expect ? null,
  glib,
  libstrophe ? null,
  libmicrohttpd,
  libuuid ? null,
  ncurses,
  openssl,
  pkg-config,
  readline,
  sqlite,

  autoAwaySupport ? true,
  libxscrnsaver ? null,
  libx11,

  notifySupport ? true,
  libnotify,
  gdk-pixbuf,

  omemoSupport ? true,
  libsignal-protocol-c ? null,
  libgcrypt,
  qrencode ? null,

  pgpSupport ? true,
  gpgme,

  pythonPluginSupport ? true,
  python3,

  traySupport ? true,
  gtk3,
  otrSupport ? true,
  libotr ? null,
  avatarScalingSupport ? true,
  spellcheckSupport ? true,
  enchant ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "profanity";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "profanity-im";
    repo = "profanity";
    tag = finalAttrs.version;
    hash = "sha256-rPiYzG5KvJyKt7b99AImmO6wTYxZPFcf/6Xhz8SrgIo=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [
    curl
    expat
    expect
    glib
    libstrophe
    libmicrohttpd
    libuuid
    ncurses
    openssl
    readline
    sqlite
  ]
  ++ lib.optionals autoAwaySupport [
    libxscrnsaver
    libx11
  ]
  ++ lib.optionals notifySupport [
    libnotify
    gdk-pixbuf
  ]
  ++ lib.optionals omemoSupport [
    libsignal-protocol-c
    libgcrypt
    qrencode
  ]
  ++ lib.optionals pgpSupport [ gpgme ]
  ++ lib.optionals pythonPluginSupport [ python3 ]
  ++ lib.optionals traySupport [ gtk3 ]
  ++ lib.optionals otrSupport [ libotr ]
  ++ lib.optionals spellcheckSupport [ enchant ]
  ++ lib.optionals avatarScalingSupport [ gdk-pixbuf ];

  mesonEntries = {
    tests = false;
  };

  mesonFeatures = {
    notifications = notifySupport;
    python-plugins = pythonPluginSupport;
    c-plugins = true;
    otr = otrSupport;
    pgp = pgpSupport;
    omemo = omemoSupport;
    omemo-qrcode = omemoSupport;
    icons-and-clipboard = traySupport;
    gdk-pixbuf = avatarScalingSupport;
    xscreensaver = autoAwaySupport;
    spellcheck = spellcheckSupport;
  };

  meta = {
    homepage = "https://profanity-im.github.io";
    description = "Console based XMPP client";
    mainProgram = "profanity";
    longDescription = ''
      Profanity is a console based XMPP client written in C using ncurses and
      libstrophe, inspired by Irssi.
    '';
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
