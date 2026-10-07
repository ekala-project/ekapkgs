{
  fetchFromGitLab,
  lib,
  stdenv,
  pkg-config,
  intltool,
  libpulseaudio,
  gtkmm4,
  libsigcxx,
  withLibcanberra ? true,
  libcanberra-gtk3,
  json-glib,
  adwaita-icon-theme,
  gtk4,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pavucontrol";
  version = "6.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pulseaudio";
    repo = "pavucontrol";
    tag = "v${finalAttrs.version}";
    hash = "sha256-If76Qt2BFgGMYt2PSzDQWmNPsbzneZ6zW9yYnS3lo84=";
  };

  buildInputs = [
    libpulseaudio
    gtkmm4
    libsigcxx
    (lib.optionals withLibcanberra libcanberra-gtk3)
    json-glib
    adwaita-icon-theme
  ];

  nativeBuildInputs = [
    pkg-config
    intltool
    gtk4.wrapGAppsHook
    meson
    meson.configurePhaseHook
    ninja
  ];

  mesonFlags = [
    "--prefix=${placeholder "out"}"
    (lib.mesonEnable "lynx" false)
  ];


  meta = {
    changelog = "https://freedesktop.org/software/pulseaudio/pavucontrol/#news";
    description = "PulseAudio Volume Control";
    homepage = "http://freedesktop.org/software/pulseaudio/pavucontrol/";
    license = lib.licenses.gpl2Plus;
    longDescription = ''
      PulseAudio Volume Control (pavucontrol) provides a GTK
      graphical user interface to connect to a PulseAudio server and
      easily control the volume of all clients, sinks, etc.
    '';
    mainProgram = "pavucontrol";
    platforms = lib.platforms.linux;
  };
})
