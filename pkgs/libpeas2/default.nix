{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  gi-docgen,
  gobject-introspection,
  meson,
  ninja,
  vala,
  glib,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "libpeas";
  version = "2.2.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-WJ7KibQ3AG7fN1VHjfA3x0CiqEz6XSAtutYJXoKOJIg=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    gi-docgen
    gobject-introspection
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    python3
  ];

  propagatedBuildInputs = [
    # Required by libpeas-2.pc
    glib
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dvapi=true"
    # gjs/spidermonkey, lua lgi, and pygobject3 are not available
    "-Dgjs=false"
    "-Dlua51=false"
    "-Dpython3=false"
  ];

  strictDeps = true;

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = {
    description = "GObject-based plugins engine";
    homepage = "https://gitlab.gnome.org/GNOME/libpeas";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
