{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  docbook-xml-dtd,
  docbook_xsl,
  intltool,
  libxml2,
  libxslt,
  pkg-config,
  gtk3,
  libx11,
  polkit,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxsession";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxsession";
    tag = finalAttrs.version;
    hash = "sha256-3RnRF4oMCtZbIraHVqEPnkviAkELq7uYqyHY0uCf/lU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    libxml2
    libxslt
    pkg-config
    vala
    gtk3.wrapGAppsHook
    docbook-xml-dtd.v4_1_2
    docbook_xsl
  ];

  buildInputs = [
    gtk3
    libx11
    polkit
  ];

  configureFlags = [
    "--enable-man"
    "--disable-buildin-clipboard"
    "--disable-buildin-polkit"
    "--enable-gtk3"
  ];

  postPatch = ''
    mkdir -p m4
  '';

  patches = [ ./repect-xml-catalog-file-var.patch ];

  meta = {
    homepage = "https://github.com/lxde/lxsession";
    description = "Classic LXDE session manager";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "lxsession";
  };
})
