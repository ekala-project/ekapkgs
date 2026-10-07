{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gtk3,
  vte,
  libgudev,
  pcre2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtkterm";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "wvdakker";
    repo = "gtkterm";
    rev = finalAttrs.version;
    sha256 = "sha256-a1GRSSyUnBkAW0HAlmoFO2R193KWSlDm3cjIIhKuNWU=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    vte
    libgudev
    pcre2
  ];

  meta = {
    description = "Simple, graphical serial port terminal emulator";
    homepage = "https://github.com/wvdakker/gtkterm";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "gtkterm";
  };
})
