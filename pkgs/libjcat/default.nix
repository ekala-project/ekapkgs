{
  stdenv,
  lib,
  fetchFromGitHub,
  docbook_xml_dtd_43,
  docbook-xsl-nons,
  glib,
  json-glib,
  gnutls,
  gpgme,
  gobject-introspection,
  vala,
  gtk-doc,
  meson,
  ninja,
  pkg-config,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "libjcat";
  version = "0.2.3";

  outputs = [
    "bin"
    "out"
    "dev"
    "devdoc"
    "man"
    "installedTests"
  ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "libjcat";
    rev = version;
    sha256 = "sha256-3Ttk5nwVLB/Ll4Xz25JODOKHsGrOxKeSF2f+6QhDI2Q=";
  };

  patches = [
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    docbook_xml_dtd_43
    docbook-xsl-nons
    gobject-introspection
    vala
    gnutls
    gtk-doc
    python3
  ];

  buildInputs = [
    glib
    json-glib
    gnutls
    gpgme
  ];

  mesonFlags = [
    "-Dgtkdoc=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Library for reading and writing Jcat files";
    mainProgram = "jcat-tool";
    homepage = "https://github.com/hughsie/libjcat";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
