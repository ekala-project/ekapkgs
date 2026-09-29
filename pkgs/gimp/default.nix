{
  stdenv,
  lib,
  fetchurl,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  babl,
  bash-completion,
  cfitsio,
  gegl,
  gtk3,
  glib,
  gdk-pixbuf,
  graphviz,
  isocodes,
  pango,
  cairo,
  libarchive,
  freetype,
  fontconfig,
  lcms2,
  libpng,
  libjpeg,
  libjxl,
  poppler,
  poppler_data,
  libtiff,
  libmng,
  librsvg,
  zlib,
  xz,
  libzip,
  ghostscript,
  aalib,
  shared-mime-info,
  python3,
  libexif,
  gettext,
  glibcLocales,
  libxslt,
  gobject-introspection,
  vala,
  gi-docgen,
  perl,
  appstream,
  desktop-file-utils,
  libxpm,
  libxmu,
  glib-networking,
  json-glib,
  libmypaint,
  gexiv2,
  harfbuzz,
  makeFontsConf,
  mypaint-brushes,
  libwebp,
  gjs,
  libgudev,
  openexr,
  xvfb-run,
  dbus,
  adwaita-icon-theme,
  alsa-lib,
  qoi,
}:

let
  python = python3.withPackages (
    pp: with pp; [
      pycairo
      pygobject3
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gimp";
  version = "3.2.4";

  outputs = [
    "out"
    "dev"
    "devdoc"
    "man"
  ];

  src = fetchurl {
    url = "https://download.gimp.org/gimp/v${lib.versions.majorMinor finalAttrs.version}/gimp-${finalAttrs.version}.tar.xz";
    hash = "sha256-cxK8U+nG0tAFbKe5PxxrmHB5Rt2TT3FMIbh0bstgFYg=";
  };

  patches = [
    # to remove compiler from the runtime closure, reference was retained via
    # gimp --version --verbose output
    (replaceVars ./remove-cc-reference.patch {
      cc_version = stdenv.cc.cc.name;
    })

    # Use absolute paths instead of relying on PATH
    # to make sure plug-ins are loaded by the correct interpreter.
    (replaceVars ./hardcode-plugin-interpreters.patch {
      python_interpreter = python.interpreter;
      PYTHON_EXE = null;
    })

    # D-Bus configuration is not available in the build sandbox
    # so we need to pick up the one from the package.
    (replaceVars ./tests-dbus-conf.patch {
      session_conf = "${dbus.out}/share/dbus-1/session.conf";
    })
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gettext
    glibcLocales
    gtk3.wrapGAppsHook
    libxslt # for xsltproc
    gobject-introspection
    perl
    python
    vala

    # for docs
    gi-docgen

    # for tests
    desktop-file-utils
    dbus
    xvfb-run
  ];

  buildInputs = [
    appstream # for library
    babl
    bash-completion
    cfitsio
    gegl
    gtk3
    glib
    gdk-pixbuf
    pango
    cairo
    libarchive
    gexiv2
    harfbuzz
    isocodes
    freetype
    fontconfig
    lcms2
    libpng
    libjpeg
    libjxl
    poppler
    poppler_data
    libtiff
    openexr
    libmng
    librsvg
    zlib
    xz
    libzip
    ghostscript
    aalib
    shared-mime-info
    json-glib
    libwebp
    python
    libexif
    libxpm
    libxmu
    glib-networking
    libmypaint
    mypaint-brushes
    qoi

    # New file dialogue crashes with "Icon 'image-missing' not present in theme Symbolic" without an icon theme.
    adwaita-icon-theme

    alsa-lib

    # for JavaScript plug-ins
    gjs
    libgudev
  ];

  propagatedBuildInputs = [
    # needed by gimp-3.0.pc
    gegl
    cairo
    pango
    gexiv2
  ];

  strictDeps = true;

  mesonFlags = [
    "-Dbug-report-url=https://github.com/NixOS/nixpkgs/issues/new"
    "-Dicc-directory=/run/current-system/sw/share/color/icc"
    "-Dcheck-update=no"
    (lib.mesonEnable "gudev" true)
    (lib.mesonEnable "headless-tests" false)
    (lib.mesonEnable "linux-input" true)
    # libheif is broken in ekapkgs (libaom cmake issue)
    "-Dheif=disabled"
    # libwmf depends on imagemagick which depends on broken libheif
    "-Dwmf=disabled"
    # libiff/libilbm broken in ekapkgs (help2man issue)
    "-Dilbm=disabled"
    # vapigen can't find gegl-0.4 vapi (vapigen disabled in gegl)
    "-Dvala=disabled"
    # Not very important to do downstream, save a dependency.
    "-Dappdata-test=disabled"
  ];

  doCheck = false;

  env = {
    # The check runs before glib-networking is registered
    GIO_EXTRA_MODULES = "${glib-networking}/lib/gio/modules";

    # Check if librsvg was built with --disable-pixbuf-loader.
    PKG_CONFIG_GDK_PIXBUF_2_0_GDK_PIXBUF_MODULEDIR = "${librsvg}/${gdk-pixbuf.moduleDir}";

    # Silence fontconfig warnings about missing config during tests
    FONTCONFIG_FILE = makeFontsConf {
      fontDirectories = [ ];
    };
  };

  postPatch = ''
    patchShebangs tools/gimp-mkenums

    # GIMP is executed at build time so we need to fix this.
    chmod +x plug-ins/python/{colorxhtml,file-openraster,foggify,gradients-save-as-css,histogram-export,palette-export-as-kpl,palette-offset,palette-sort,palette-to-gradient,python-eval,spyro-plus}.py
    patchShebangs \
      plug-ins/python/{colorxhtml,file-openraster,foggify,gradients-save-as-css,histogram-export,palette-export-as-kpl,palette-offset,palette-sort,palette-to-gradient,python-eval,spyro-plus}.py
  '';

  preBuild = ''
    # Set HOME so GIMP can create config directories during build
    export HOME="$TMPDIR"

    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When running GIMP in build or check phase, it will try
    # to use plug-ins, which import GIMP introspection files which will try
    # to load the GIMP libraries which will not be installed yet.
    # So we need to replace the absolute path with a local one.
    # We are using a symlink that will be overridden during installation.
    mkdir -p "$out/lib"
    ln -s "$PWD/libgimp/libgimp-3.0.so.0" \
      "$PWD/libgimpbase/libgimpbase-3.0.so.0" \
      "$PWD/libgimpcolor/libgimpcolor-3.0.so.0" \
      "$PWD/libgimpconfig/libgimpconfig-3.0.so.0" \
      "$PWD/libgimpmath/libgimpmath-3.0.so.0" \
      "$PWD/libgimpmodule/libgimpmodule-3.0.so.0" \
      "$out/lib/"
  '';

  preCheck = ''
    # Avoid "Error retrieving accessibility bus address"
    export NO_AT_BRIDGE=1
    # Fix storing recent file list in tests
    export HOME="$TMPDIR"
    export XDG_DATA_DIRS="${glib.getSchemaDataDirPath gtk3}:${adwaita-icon-theme}/share:$XDG_DATA_DIRS"
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${
      lib.makeBinPath [
        # for dot for gegl:introspect (Debug > Show Image Graph, hidden by default on stable release)
        graphviz
        # for gimp-script-fu-interpreter-3.0 invoked by shebang of some plug-ins
        "$out"
      ]
    }"
    --suffix XDG_DATA_DIRS : "${adwaita-icon-theme}/share")
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    # The declarations for `gimp-with-plugins` wrapper,
    # used for determining plug-in installation paths
    apiVersion = "${
      toString (
        lib.toInt (lib.versions.major finalAttrs.version)
        + (if lib.versions.minor finalAttrs.version == "99" then 1 else 0)
      )
    }.0";
    appVersion = lib.versions.majorMinor finalAttrs.version;
    targetLibDir = "lib/gimp/${finalAttrs.passthru.apiVersion}";
    targetDataDir = "share/gimp/${finalAttrs.passthru.apiVersion}";
    targetPluginDir = "${finalAttrs.passthru.targetLibDir}/plug-ins";
    targetScriptDir = "${finalAttrs.passthru.targetDataDir}/scripts";

    # probably its a good idea to use the same gtk in plugins ?
    gtk = gtk3;
  };

  meta = {
    description = "GNU Image Manipulation Program";
    homepage = "https://www.gimp.org/";
    donationPage = "https://www.gimp.org/donating/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    # Build invokes built binary to convert assets, binary hangs during plugin loading on big-endian platforms (s390x, ppc64)
    # https://gitlab.gnome.org/GNOME/gimp/-/issues/12522
    broken = stdenv.hostPlatform.isBigEndian;
    mainProgram = "gimp";
  };
})
