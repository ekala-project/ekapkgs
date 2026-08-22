{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  vala,
  gi-docgen,
  glib,
  gtk4,
  libadwaita,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpanel";
  version = "1.10.4";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/libpanel/${lib.versions.majorMinor finalAttrs.version}/libpanel-${finalAttrs.version}.tar.xz";
    hash = "sha256-WTiIp2kfCviqpuGTyeFK+oaoEMDC8nUVxtgT8Yczsc0=";
  };

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gi-docgen
    gtk4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  mesonFlags = [
    (lib.mesonBool "install-examples" true)
  ];

  postFixup = ''
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = {
    description = "Dock/panel library for GTK 4";
    mainProgram = "libpanel-example";
    homepage = "https://gitlab.gnome.org/GNOME/libpanel";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
