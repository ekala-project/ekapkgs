{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
  pkg-config,
  intltool,
  libxml2,
  perlPackages,
  goffice,
  adwaita-icon-theme,
  wrapGAppsHook3,
  glib,
  gtk3,
  bison,
  python3,
  itstool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnumeric";
  version = "1.12.59";

  src = fetchurl {
    url = "mirror://gnome/sources/gnumeric/${lib.versions.majorMinor finalAttrs.version}/gnumeric-${finalAttrs.version}.tar.xz";
    sha256 = "yzdQsXbWQflCPfchuDFljIKVV1UviIf+34pT2Qfs61E=";
  };

  configureFlags = [
    "--disable-component"
    "--without-python"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
    intltool
    bison
    itstool
    glib # glib-compile-resources
    libxml2 # xmllint
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    goffice
    gtk3
    adwaita-icon-theme
  ]
  ++ (with perlPackages; [
    perl
    XMLParser
  ]);

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail 'GLIB_COMPILE_RESOURCES=' 'GLIB_COMPILE_RESOURCES="glib-compile-resources"#'
    # Prevent automake from trying to re-run after configure.ac changes
    touch aclocal.m4 configure Makefile.in
  '';

  meta = with lib; {
    description = "GNOME Office Spreadsheet";
    license = licenses.gpl2Plus;
    homepage = "http://projects.gnome.org/gnumeric/";
    platforms = platforms.unix;
  };
})
