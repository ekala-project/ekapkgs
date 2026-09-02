{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  gettext,
  intltool,
  libtool,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  libxcb,
  libdrm,
  libxxf86vm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "redshift";
  version = "1.12";

  src = fetchFromGitHub {
    owner = "jonls";
    repo = "redshift";
    rev = "v${finalAttrs.version}";
    sha256 = "12cb4gaqkybp4bkkns8pam378izr2mwhr2iy04wkprs2v92j7bz6";
  };

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    intltool
    libtool
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libxcb
    libdrm
    libxxf86vm
  ];

  configureFlags = [
    "--enable-randr=yes"
    "--enable-geoclue2=no"
    "--enable-drm=yes"
    "--enable-vidmode=yes"
    "--enable-quartz=no"
    "--enable-corelocation=no"
  ];

  preConfigure = "./bootstrap";

  enableParallelBuilding = true;

  meta = {
    description = "Screen color temperature manager";
    license = lib.licenses.gpl3Plus;
    homepage = "http://jonls.dk/redshift";
    platforms = lib.platforms.linux;
    mainProgram = "redshift";
  };
})
