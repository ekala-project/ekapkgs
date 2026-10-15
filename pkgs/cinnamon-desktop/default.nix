{
  fetchFromGitHub,
  gdk-pixbuf,
  gobject-introspection,
  gtk3,
  intltool,
  isocodes,
  meson,
  ninja,
  pkg-config,
  pulseaudio,
  python3,
  lib,
  stdenv,
  systemdLibs,
  xkeyboard-config,
  libxrandr,
  libxext,
  libxkbfile,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cinnamon-desktop";
  version = "6.6.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-desktop";
    tag = finalAttrs.version;
    hash = "sha256-AcUJ9anKuvUAJKaQVHbkYShmrlSHG35gV/NIkPgJojk=";
  };

  outputs = [
    "out"
    "dev"
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    pulseaudio
  ];

  buildInputs = [
    gdk-pixbuf
    isocodes
    systemdLibs
    xkeyboard-config
    libxkbfile
    libxext
    libxrandr
  ];

  nativeBuildInputs = [
    meson
    ninja
    python3
    gtk3.wrapGAppsHook
    intltool
    pkg-config
    gobject-introspection
  ];

  postPatch = ''
    chmod +x install-scripts/meson_install_schemas.py # patchShebangs requires executable file
    patchShebangs install-scripts/meson_install_schemas.py
    sed "s|/usr/share|/run/current-system/sw/share|g" -i ./schemas/* # NOTE: unless this causes a circular dependency, we could link it to cinnamon/share/cinnamon
  '';

  meta = {
    homepage = "https://github.com/linuxmint/cinnamon-desktop";
    description = "Library and data for various Cinnamon modules";
    license = [
      lib.licenses.gpl2
      lib.licenses.lgpl2
    ];
    platforms = lib.platforms.linux;
  };
})
