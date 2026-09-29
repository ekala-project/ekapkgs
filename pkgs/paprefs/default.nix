{
  fetchurl,
  lib,
  stdenv,
  meson,
  ninja,
  gettext,
  pkg-config,
  pulseaudio,
  glibmm,
  gtkmm3,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "paprefs";
  version = "1.2";

  src = fetchurl {
    url = "https://freedesktop.org/software/pulseaudio/paprefs/paprefs-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-s/IeQNw5NtFeP/yRD7DAfBS4jowodxW0VqlIwXY49jM=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    gettext
    pkg-config
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    pulseaudio
    glibmm
    gtkmm3
  ];

  meta = {
    description = "PulseAudio Preferences";
    mainProgram = "paprefs";

    longDescription = ''
      PulseAudio Preferences (paprefs) is a simple GTK based configuration
      dialog for the PulseAudio sound server.
    '';

    homepage = "http://freedesktop.org/software/pulseaudio/paprefs/";

    license = lib.licenses.gpl2Plus;

    platforms = lib.platforms.linux;
  };
})
