{
  stdenv,
  lib,
  intltool,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  python3,
  gtk3,
  pcre2,
  glib,
  desktop-file-utils,
  gtk-doc,
  wrapGAppsHook3,
  itstool,
  libxml2,
  yelp-tools,
  docbook_xsl,
  docbook_xml_dtd_45,
  gsettings-desktop-schemas,
  unzip,
  unicode-character-database,
  unihan-database,
  runCommand,
  symlinkJoin,
  gobject-introspection,
}:

let
  unihanZip = runCommand "unihan" { } ''
    mkdir -p $out/share/unicode
    ln -s ${unihan-database.src} $out/share/unicode/Unihan.zip
  '';
  ucd = symlinkJoin {
    name = "ucd+unihan";
    paths = [
      unihanZip
      unicode-character-database
    ];
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "gucharmap";
  version = "17.0.2";

  outputs = [
    "out"
    "lib"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gucharmap";
    rev = finalAttrs.version;
    hash = "sha256-LjXn8cFLqVZmLub0FRscyjg93u6g1EXsv3w0L4iiyqE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    wrapGAppsHook3
    unzip
    intltool
    itstool
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_45
    yelp-tools
    libxml2
    desktop-file-utils
  ];

  buildInputs = [
    gtk3
    glib
    gsettings-desktop-schemas
    pcre2
  ];

  mesonFlags = [
    "-Ducd_path=${ucd}/share/unicode"
    "-Dvapi=false"
    "-Dgir=false"
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs \
      data/meson_desktopfile.py \
      gucharmap/gen-guch-unicode-tables.pl
  '';

  meta = {
    description = "GNOME Character Map, based on the Unicode Character Database";
    mainProgram = "gucharmap";
    homepage = "https://gitlab.gnome.org/GNOME/gucharmap";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
