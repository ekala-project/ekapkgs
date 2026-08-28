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

  # TODO: not yet available in ekapkgs
  # gnome-online-accounts (being ported),
  # gcr,
  # p11-kit,
  # openssl,
  # uhttpmock,
  # libsoup_2_4 — this package needs libsoup 2.x, not libsoup 3
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
    # TODO: gcr not available
    # gcr
    # TODO: openssl — may need to add
    # openssl
    # TODO: p11-kit not available
    # p11-kit
    # TODO: uhttpmock not available
    # uhttpmock
  ];

  propagatedBuildInputs = [
    glib
    # TODO: libsoup_2_4 — this package uses libsoup 2.x API
    # libsoup_2_4
    libxml2
    # TODO: gnome-online-accounts (being ported)
    # gnome-online-accounts
    json-glib
  ];

  mesonFlags = [
    "-Dgtk_doc=false"
    "-Dinstalled_tests=false"
    # TODO: re-enable GOA once gnome-online-accounts is ported
    "-Dgoa=disabled"
  ];

  meta = {
    description = "GData API library";
    homepage = "https://gitlab.gnome.org/GNOME/libgdata";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
