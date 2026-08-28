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
  wrapGAppsHook3,
  pcre2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtkterm";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "wvdakker";
    repo = "gtkterm";
    rev = finalAttrs.version;
    sha256 = "sha256-oGqOXIu5P3KfdV6Unm7Nz+BRhb5Z6rne0+e0wZ2EcAI=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wrapGAppsHook3
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
