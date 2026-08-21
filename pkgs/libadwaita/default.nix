{
  lib,
  stdenv,
  fetchFromGitLab,
  gi-docgen,
  meson,
  ninja,
  pkg-config,
  sassc,
  vala,
  gobject-introspection,
  appstream,
  fribidi,
  glib,
  gtk4,
  adwaita-icon-theme,
  gsettings-desktop-schemas,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libadwaita";
  version = "1.9.2";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];
  outputBin = "devdoc"; # demo app

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libadwaita";
    tag = finalAttrs.version;
    hash = "sha256-XKKjnZz4CII6w9fKFptPK3aTNa5eMfyE7rcerbgaDco=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    gi-docgen
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    sassc
    vala
    gobject-introspection
    desktop-file-utils # for validate-desktop-file
  ];

  mesonFlags = [
    "-Ddocumentation=true"
  ]
  ++ lib.optionals (!finalAttrs.finalPackage.doCheck) [
    "-Dtests=false"
  ];

  buildInputs = [
    appstream
    fribidi
  ];

  propagatedBuildInputs = [
    gtk4
  ];

  separateDebugInfo = true;

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"

    # Put all resources related to demo app into devdoc output.
    for d in applications icons metainfo; do
      moveToOutput "share/$d" "$devdoc"
    done
  '';

  meta = {
    changelog = "https://gitlab.gnome.org/GNOME/libadwaita/-/blob/${finalAttrs.src.tag}/NEWS";
    description = "Library to help with developing UI for mobile devices using GTK/GNOME";
    mainProgram = "adwaita-1-demo";
    homepage = "https://gitlab.gnome.org/GNOME/libadwaita";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "libadwaita-1" ];
  };
})
