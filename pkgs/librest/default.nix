{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  glib,
  json-glib,
  libsoup,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "rest";
  version = "0.9.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "kmalwQ7OOD4ZPft/+we1CcwfUVIauNrXavlu0UISwuM=";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/librest/-/commit/fbad64abe28a96f591a30e3a5d3189c10172a414.patch";
      hash = "sha256-r8+h84Y/AdM1IOMRcBVwDvfqapqOY8ZtRXdOIQvFR9w=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/librest/-/commit/8049048a0f7d52b3f4101c7123797fed099d4cc8.patch";
      hash = "sha256-AMhHKzzOoTIlkRwN4KfUwdhxlqvtRgiVjKRfnG7KZwc=";
    })
  ];

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  propagatedBuildInputs = [
    glib
    json-glib
    libsoup
    libxml2
  ];

  mesonFlags = [
    "-Dexamples=false"
    "-Dintrospection=false"
    "-Dgtk_doc=false"
    "-Dca_certificates=true"
    "-Dca_certificates_path=/etc/ssl/certs/ca-certificates.crt"
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace "con." "conf."
  '';

  meta = {
    description = "Helper library for RESTful services";
    homepage = "https://gitlab.gnome.org/GNOME/librest";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.unix;
  };
}
