{
  stdenv,
  lib,
  fetchFromGitLab,
  pkg-config,
  glib,
  sqlite,
  gobject-introspection,
  vala,
  autoconf,
  automake,
  libtool,
  gettext,
  dbus,
  gtk3,
  json-glib,
  librdf_raptor2,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zeitgeist";
  version = "1.0.4";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "zeitgeist";
    repo = "zeitgeist";
    rev = "v${finalAttrs.version}";
    sha256 = "kG1N8DXgjYAJ8fbrGHsp7eTqB20H5smzRnW0PSRUYR0=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    gettext
    gobject-introspection
    vala
    python3
  ];

  buildInputs = [
    glib
    sqlite
    dbus
    gtk3
    json-glib
    librdf_raptor2
    python3.pkgs.rdflib
  ];

  configureFlags = [
    "--disable-telepathy"
  ];

  postPatch = ''
    patchShebangs data/ontology2code
  '';

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  meta = {
    description = "Service which logs the users's activities and events";
    homepage = "https://zeitgeist.freedesktop.org/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
