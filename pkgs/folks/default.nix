{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  glib,
  gettext,
  gobject-introspection,
  vala,
  sqlite,
  dbus,
  libgee,
  python3,
  readline,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_43,

  # TODO: not yet available in ekapkgs
  # evolution-data-server-gtk4,
  # dbus-glib,
  # telepathy-glib,
}:

# TODO: enable more folks backends

stdenv.mkDerivation (finalAttrs: {
  pname = "folks";
  version = "0.15.12";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/folks/${lib.versions.majorMinor finalAttrs.version}/folks-${finalAttrs.version}.tar.xz";
    hash = "sha256-IfROK9q7Huf45Bu5ltEKx9rzXHjEmBd9sMAPWAogqRQ=";
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/folks/-/merge_requests/81
    ./fix-docs-build-with-eds-3.59.patch
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    # TODO: re-enable docs when gtk-doc issues sorted
    # gtk-doc
    # docbook-xsl-nons
    # docbook_xml_dtd_43
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    # TODO: dbus-glib not yet available
    # dbus-glib
    # TODO: evolution-data-server-gtk4 being ported
    # evolution-data-server-gtk4
    readline
  ];

  propagatedBuildInputs = [
    glib
    libgee
    sqlite
  ];

  nativeCheckInputs = [
    dbus
    (python3.withPackages (
      pp: with pp; [
        python-dbusmock
        dbus-python
        pygobject3
      ]
    ))
  ];

  mesonFlags = [
    "-Ddocs=false"
    "-Dtelepathy_backend=false"
    "-Dtests=false"
    # TODO: re-enable EDS backend once evolution-data-server is ported
    "-Deds_backend=false"
  ];

  doCheck = false;

  meta = {
    description = "Library that aggregates people from multiple sources to create metacontacts";
    homepage = "https://gitlab.gnome.org/GNOME/folks";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
