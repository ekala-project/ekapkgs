{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  intltool,
  gtk2,
  libx11,
  xrandr,
  withGtk3 ? false,
  gtk3,
  autoreconfHook,
  libxslt,
  docbook_xsl,
  docbook-xml-dtd,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxrandr";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxrandr";
    tag = finalAttrs.version;
    hash = "sha256-EGUnvV1FqQUJkjGwxgVecXOohAu8Qa8Prgk6xZfJBe4=";
  };

  configureFlags = [
    "--enable-man"
  ]
  ++ lib.optional withGtk3 "--enable-gtk3";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    intltool
    libxslt
    libxml2
    docbook-xml-dtd.v4_1_2
    docbook_xsl
  ];

  patches = [ ./respect-xml-catalog-files-var.patch ];

  buildInputs = [
    libx11
    xrandr
    (if withGtk3 then gtk3 else gtk2)
  ];

  meta = {
    description = "Standard screen manager of LXDE";
    mainProgram = "lxrandr";
    homepage = "https://lxde.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
