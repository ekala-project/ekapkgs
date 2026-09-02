{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  replaceVars,
  atk,
  cairo,
  cups,
  gdk-pixbuf,
  gettext,
  glib,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxi,
  libxinerama,
  libxrandr,
  libxrender,
  pango,
  perl,
  pkg-config,
  gdktarget ? "x11",
  cupsSupport ? stdenv.hostPlatform.isLinux,
  xineramaSupport ? stdenv.hostPlatform.isLinux,
}:

let
  gtkCleanImmodulesCache = replaceVars ./hooks/clean-immodules-cache.sh {
    gtk_module_path = "gtk-2.0";
    gtk_binary_version = "2.10.0";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "gtk+";
  version = "2.24.33";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/2.24/gtk+-${finalAttrs.version}.tar.xz";
    hash = "sha256-rCrHV/WULTGKMRpUsMgLXvKV8pnCpzxjL2v7H/Scxto=";
  };

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];
  outputBin = "dev";

  setupHooks = [
    ./hooks/drop-icon-theme-cache.sh
    gtkCleanImmodulesCache
  ];

  nativeBuildInputs = finalAttrs.setupHooks ++ [
    gdk-pixbuf
    gettext
    perl
    pkg-config
  ];

  patches = [
    ./patches/2.0-immodules.cache.patch
    ./patches/gtk2-theme-paths.patch
    (fetchpatch {
      name = "CVE-2024-6655.patch";
      url = "https://gitlab.gnome.org/GNOME/gtk/-/commit/3bbf0b6176d42836d23c36a6ac410e807ec0a7a7.patch";
      hash = "sha256-mstOPk9NNpUwScrdEbvGhmAv8jlds3SBdj53T0q33vM=";
    })
  ];

  propagatedBuildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    pango
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libxcomposite
    libxcursor
    libxi
    libxrandr
    libxrender
  ]
  ++ lib.optional xineramaSupport libxinerama
  ++ lib.optional cupsSupport cups;

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-gdktarget=${gdktarget}"
    "--with-xinput=yes"
    "--disable-introspection"
  ];

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-int"
      "-Wno-error=incompatible-pointer-types"
    ];
  };

  enableParallelBuilding = true;

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
  ];

  doCheck = false;

  postInstall = ''
    moveToOutput share/gtk-2.0/demo "$devdoc"
    moveToOutput bin/gtk-update-icon-cache "$out"
  '';

  passthru = {
    gtkExeEnvPostBuild = ''
      rm $out/lib/gtk-2.0/2.10.0/immodules.cache
      $out/bin/gtk-query-immodules-2.0 $out/lib/gtk-2.0/2.10.0/immodules/*.so > $out/lib/gtk-2.0/2.10.0/immodules.cache
    '';
    inherit gdktarget;
  };

  meta = {
    homepage = "https://www.gtk.org/";
    description = "Multi-platform toolkit for creating graphical user interfaces";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.all;
  };
})
