{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  vala,
  gettext,
  libxml2,
  glib,
  json-glib,
  gobject-introspection,

  gnome-online-accounts,
  gcr,
  p11-kit,
  openssl,
  # TODO: uhttpmock - not yet available in ekapkgs
  # TODO: libsoup_2_4 — this package needs libsoup 2.x, not libsoup 3
}:

stdenv.mkDerivation rec {
  pname = "libgdata";
  version = "0.18.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "3YWS7rZRKtCoz1yL6McudvdL/msj5N2T8HVu4HFoBMc=";
  };

  patches = [
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gcr
    openssl
    p11-kit
    # TODO: uhttpmock - not yet available in ekapkgs
    # uhttpmock
  ];

  propagatedBuildInputs = [
    glib
    # TODO: libsoup_2_4 — this package uses libsoup 2.x API
    # libsoup_2_4
    libxml2
    gnome-online-accounts
    json-glib
  ];

  mesonFlags = [
    "-Dgtk_doc=false"
    "-Dinstalled_tests=false"
  ];

  meta = {
    description = "GData API library";
    homepage = "https://gitlab.gnome.org/GNOME/libgdata";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
