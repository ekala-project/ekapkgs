{
  lib,
  stdenv,
  fetchFromGitLab,
  intltool,
  meson,
  ninja,
  pkg-config,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_412,
  glib,
  json-glib,
  libsoup,
  avahi,
  glib-networking,
  python3,
  wrapGAppsNoGuiHook,
  gobject-introspection,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geoclue";
  version = "2.7.2";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "geoclue";
    repo = "geoclue";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-LwL1WtCdHb/NwPr3/OLISwaAwplhJwiZT9vUdX29Bbs=";
  };

  patches = [
    ./add-option-for-installation-sysconfdir.patch
  ];

  nativeBuildInputs = [
    pkg-config
    intltool
    meson
    meson.configurePhaseHook
    ninja
    wrapGAppsNoGuiHook
    python3
    vala
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_412
  ];

  buildInputs = [
    glib
    json-glib
    libsoup
    avahi
  ];

  propagatedBuildInputs = [
    glib
    glib-networking
  ];

  mesonFlags = [
    "-Dsystemd-system-unit-dir=${placeholder "out"}/lib/systemd/system"
    "-Ddemo-agent=false"
    "--sysconfdir=/etc"
    "-Dsysconfdir_install=${placeholder "out"}/etc"
    "-Ddbus-srv-user=geoclue"
    "-D3g-source=false"
    "-Dcdma-source=false"
    "-Dmodem-gps-source=false"
  ];

  postPatch = ''
    chmod +x demo/install-file.py
    patchShebangs demo/install-file.py
  '';

  meta = {
    description = "Geolocation framework and some data providers";
    homepage = "https://gitlab.freedesktop.org/geoclue/geoclue/wikis/home";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
})
