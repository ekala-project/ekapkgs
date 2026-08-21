{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  glib,
  json-glib,
  pkg-config,
  gobject-introspection,
  vala,
  gi-docgen,
}:

stdenv.mkDerivation rec {
  pname = "jsonrpc-glib";
  version = "3.44.2";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/jsonrpc-glib/${lib.versions.majorMinor version}/jsonrpc-glib-${version}.tar.xz";
    sha256 = "llSWtuExTzRotIKl2ANA3DsDQKVALXeDytJBVK7nc5Y=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gobject-introspection
    vala
    gi-docgen
  ];

  buildInputs = [
    glib
    json-glib
  ];

  mesonFlags = [
    "-Denable_gtk_doc=true"
  ];

  # Tests fail non-deterministically
  # https://gitlab.gnome.org/GNOME/jsonrpc-glib/issues/2
  doCheck = false;

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = {
    description = "Library to communicate using the JSON-RPC 2.0 specification";
    homepage = "https://gitlab.gnome.org/GNOME/jsonrpc-glib";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
}
