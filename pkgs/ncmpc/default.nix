{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  sphinx ? null,
  glib,
  ncurses,
  libmpdclient,
  gettext,
  boost,
  fmt,
  pcre2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncmpc";
  version = "0.54";

  src = fetchFromGitHub {
    owner = "MusicPlayerDaemon";
    repo = "ncmpc";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-POeMWDpN0tXo/8NpDVHv9MGAe5O6fukVph3rfmjACZY=";
  };

  buildInputs = [
    glib
    ncurses
    libmpdclient
    boost
    fmt
    pcre2
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
  ]
  ++ lib.optionals (sphinx != null) [ sphinx ];

  mesonFlags = [
    (lib.mesonEnable "lirc" false)
  ];

  outputs = [
    "out"
    "doc"
  ];

  meta = {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage = "https://www.musicpd.org/clients/ncmpc/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
    mainProgram = "ncmpc";
  };
})
