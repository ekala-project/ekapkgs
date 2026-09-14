{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  scdoc,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  pam,
  gtk-session-lock,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtklock";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "jovanlanik";
    repo = "gtklock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-e/JRJtQAyIvQhL5hSbY7I/f12Z9g2N0MAHQvX+aXz8Q=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    scdoc
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    pam
    gtk-session-lock
  ];

  strictDeps = true;

  meta = {
    description = "GTK-based lockscreen for Wayland";
    longDescription = ''
      Important note: for gtklock to work you need to set "security.pam.services.gtklock = {};" manually.
      Otherwise you'll lock yourself out of desktop and unable to authenticate.
    '';
    homepage = "https://github.com/jovanlanik/gtklock";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "gtklock";
  };
})
