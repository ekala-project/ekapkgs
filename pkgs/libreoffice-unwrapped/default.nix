{
  stdenv,
  fetchurl,
  fetchgit,
  fetchpatch2,
  fetchFromGitLab,
  lib,
  pam,
  python3,
  python3Packages,
  libxslt,
  perl,
  perlPackages,
  box2d,
  gettext,
  zlib,
  libjpeg,
  liblangtag,
  expat,
  freetype,
  libwpd,
  libxml2,
  db,
  curl,
  fontconfig,
  libsndfile,
  neon,
  bison,
  flex,
  zip,
  unzip,
  fast-float,
  md4c,
  gtk3,
  libmspack,
  getopt,
  file,
  cairo,
  which,
  icu,
  boost,
  java,
  ant,
  cups,
  libixion,
  libxtst,
  libxi,
  libxinerama,
  libxext,
  libxdmcp,
  libxaw,
  libx11,
  libpthread-stubs,
  libxshmfence,
  fontforge,
  openssl,
  gperf,
  cppunit,
  poppler,
  util-linux,
  librsvg,
  libGLU,
  libGL,
  bsh,
  coinmp,
  libwps,
  libabw,
  libargon2,
  libmysqlclient,
  autoconf,
  automake,
  openldap,
  bash,
  hunspell,
  librdf_rasqal,
  redland,
  nss,
  nspr,
  libwpg,
  dbus-glib,
  clucene-core,
  libcdr,
  lcms2,
  unixodbc,
  mdds,
  sane-backends,
  mythes,
  libexttextcat,
  libvisio,
  pkg-config,
  bluez,
  libtool,
  libatomic_ops,
  graphite2,
  harfbuzz,
  libodfgen,
  libzmf,
  librevenge,
  libe-book,
  libmwaw,
  glm,
  gstreamer,
  gdb,
  adwaita-icon-theme,
  glib,
  ncurses,
  libepoxy,
  gpgme,
  gpgmepp,
  libwebp,
  abseil-cpp,
  # libfreehand,  # using bundled version (system version fails to build)
  libepubgen,
  libetonyek,
  libpng,
  liborcus,
  libxcrypt,
  langs ? [
    "ar"
    "ca"
    "cs"
    "da"
    "de"
    "en-GB"
    "en-US"
    "eo"
    "es"
    "fi"
    "fr"
    "hu"
    "it"
    "ja"
    "ko"
    "nl"
    "pl"
    "pt"
    "pt-BR"
    "ro"
    "ru"
    "sk"
    "sl"
    "tr"
    "uk"
    "zh-CN"
    "zh-TW"
  ],
  withFonts ? false,
  withHelp ? true,
  withJava ? true,
  kdeIntegration ? false,
  qt6,
  kdePackages,
  symlinkJoin,
  libpq,
  makeFontsConf,
  amiri,
  caladea,
  carlito,
  culmus,
  dejavu_fonts,
  rubik,
  liberation-sans-narrow,
  liberation_ttf,
  libertine,
  linux-libertine-g,
  noto-fonts,
  noto-fonts-cjk-sans,
  # rhino,  # gradle deps incomplete, JS macro support disabled
  lp_solve,
  xmlsec,
  libcmis,
  frozen-containers,
}:

let
  inherit (lib)
    flatten
    flip
    concatMapStrings
    concatStringsSep
    getDev
    getLib
    optionals
    optionalString
    ;

  fontsConf = makeFontsConf {
    fontDirectories = [
      amiri
      caladea
      carlito
      culmus
      dejavu_fonts
      rubik
      liberation-sans-narrow
      liberation_ttf
      libertine
      linux-libertine-g
      noto-fonts
      noto-fonts-cjk-sans
    ];
  };

  jre' = java;

  version = import ./src-stable/version.nix;
  srcsAttributes = {
    main = import ./src-stable/main.nix;
    help = import ./src-stable/help.nix;
    translations = import ./src-stable/translations.nix;
    deps = import ./src-stable/deps.nix;
  };
  srcs = {
    third_party = map (
      x:
      (fetchurl {
        inherit (x) url sha256 name;
      })
      // {
        inherit (x) md5name md5;
      }
    ) srcsAttributes.deps;
    translations = srcsAttributes.translations { inherit fetchurl fetchgit; };
    help = srcsAttributes.help { inherit fetchurl fetchgit; };
  };

  kdeDependencies = [
    qt6.qtbase.out
    qt6.qtmultimedia.out
    kdePackages.kconfig
    kdePackages.kcoreaddons
    kdePackages.ki18n
    kdePackages.kio
    kdePackages.kwindowsystem
  ];
  mkKdeDeps =
    pkgs: func:
    symlinkJoin {
      name = "libreoffice-kde-dependencies-${version}";
      paths = flatten (
        map (e: [
          (func e)
        ]) pkgs
      );
    };
  kdeDepsIncludes = mkKdeDeps kdeDependencies getDev;
  kdeDepsLibs = mkKdeDeps kdeDependencies getLib;

  tarballPath = "external/tarballs";

in
stdenv.mkDerivation (finalAttrs: {
  pname = "libreoffice";
  inherit version;

  src = srcsAttributes.main { inherit fetchurl fetchgit; };

  postUnpack = ''
    mkdir -v $sourceRoot/${tarballPath}

    ${flip concatMapStrings srcs.third_party (f: ''
      ln -sfv ${f} $sourceRoot/${tarballPath}/${f.md5name}
      ln -sfv ${f} $sourceRoot/${tarballPath}/${f.name}
    '')}

    ln -sv ${srcs.help} $sourceRoot/${tarballPath}/${srcs.help.name}
    ln -svf ${srcs.translations} $sourceRoot/${tarballPath}/${srcs.translations.name}

    tar -xf ${srcs.help}
    tar -xf ${srcs.translations}
  '';

  patches = [
    ./skip-broken-tests.patch
    ./skip-broken-tests-stable.patch
    ./dont-detect-qt-paths-from-qmake.patch
    # Revert part of a commit that broke zlib linking
    ./readd-explicit-zlib-link.patch
  ]
  ++ lib.optionals (lib.versionAtLeast version "26.8" && lib.versionOlder version "26.8.999") [
    ./26.8-add-dir-prereq.patch
  ];

  postPatch = ''
    # configure checks for header 'gpgme++/gpgmepp_version.h',
    # and if it is found (no matter where) uses a hardcoded path.
    # Fix this path to point to where the headers can actually be found.
    substituteInPlace configure.ac --replace-fail \
      'GPGMEPP_CFLAGS=-I/usr/include/gpgme++' \
      'GPGMEPP_CFLAGS=-I${lib.getDev gpgmepp}/include/gpgme++'

    # Fix for Python 3.12
    substituteInPlace configure.ac --replace-fail distutils.sysconfig sysconfig
  '';

  nativeBuildInputs = [
    autoconf
    automake
    bison
    flex
    fontforge
    gdb
    gettext
    gperf
    icu
    libmysqlclient
    libtool
    libxml2
    libxslt
    perl
    perlPackages.ArchiveZip
    pkg-config
    python3
    unzip
    zip
  ]
  ++ optionals kdeIntegration [
    qt6.qtbase
  ]
  ++ optionals withJava [
    ant
    java
  ];

  buildInputs =
    finalAttrs.passthru.gst_packages
    ++ [
      # Make libpng not handle APNG images, so LibreOffice's own handler kicks in
      (libpng.override { apngSupport = false; })
      coinmp
      abseil-cpp
      bluez
      boost
      cairo
      clucene-core
      cppunit
      cups
      curl
      db
      dbus-glib
      expat
      file
      fontconfig
      freetype
      getopt
      glib
      glm
      adwaita-icon-theme
      gpgme
      gpgmepp
      graphite2
      gtk3
      (harfbuzz.override { withIcu = true; })
      hunspell
      icu
      lcms2
      libGL
      libGLU
      libtool
      libx11
      libxaw
      libxdmcp
      libxext
      libxi
      libxinerama
      libxtst
      libabw
      libargon2
      libcdr
      libcmis
      # libfreehand  # using bundled version
      libe-book
      libepoxy
      libepubgen
      libetonyek
      libexttextcat
      libjpeg
      liblangtag
      libmspack
      libmwaw
      libodfgen
      liborcus
      libpthread-stubs
      redland
      librevenge
      librsvg
      libsndfile
      libvisio
      libwpd
      libwpg
      libwps
      libxcrypt
      libxml2
      libxshmfence
      libxslt
      libzmf
      libwebp
      lp_solve
      mdds
      mythes
      ncurses
      neon
      nspr
      nss
      openldap
      openssl
      pam
      poppler
      libpq
      python3
      sane-backends
      unixodbc
      util-linux
      which
      xmlsec
      zlib
      frozen-containers
      md4c
      fast-float
    ]
    ++ optionals kdeIntegration [
      qt6.qtbase
      kdePackages.kcoreaddons
      kdePackages.kio
    ]
    ++ optionals withJava [
      jre'
    ];

  preConfigure = ''
    configureFlagsArray=(
      "--with-parallelism=$NIX_BUILD_CORES"
      "--with-lang=${concatStringsSep " " langs}"
    );

    patchShebangs .

    NOCONFIGURE=1 ./autogen.sh
  ''
  + optionalString kdeIntegration ''
    export QT6INC=${kdeDepsIncludes}/include
    export QT6LIB=${kdeDepsLibs}/lib
    export KF6INC="${kdeDepsIncludes}/include ${kdeDepsIncludes}/include/KF6"
    export KF6LIB=${kdeDepsLibs}/lib
  '';

  configureFlags = [
    "--host=${stdenv.hostPlatform.config}"
    "--without-buildconfig-recorded"

    (lib.withFeature withHelp "help")
    "--with-boost=${getDev boost}"
    "--with-boost-libdir=${getLib boost}/lib"
    "--with-vendor=EkaOS"
    "--disable-report-builder"
    "--disable-online-update"
    "--enable-python=system"
    "--enable-dbus"
    "--enable-release-build"
    "--enable-epm"
    (lib.withFeature withJava "java")

    "--without-junit"
    "--without-export-validation"
    "--disable-fetch-external"
    "--enable-build-opensymbol"
    "--disable-odk"
    "--disable-firebird-sdbc"
    (lib.withFeature withFonts "fonts")
    "--without-doxygen"

    "--with-system-cairo"
    "--with-system-coinmp"
    "--with-system-fast-float"
    "--with-system-headers"
    "--with-system-libabw"
    "--with-system-libcmis"
    "--without-system-libfreehand" # corepkgs version fails with newer compilers
    "--with-system-libepubgen"
    "--with-system-libetonyek"
    "--with-system-liblangtag"
    "--with-system-libs"
    "--with-system-libwps"
    "--with-system-lpsolve"
    "--with-system-mdds"
    "--with-system-openldap"
    "--with-system-openssl"
    "--with-system-orcus"
    "--with-system-postgresql"
    "--with-system-xmlsec"
    "--with-system-frozen"

    # Bundled; not using system versions
    "--without-system-altlinuxhyph"
    "--without-system-libeot"
    "--without-system-libmspub"
    "--without-system-libnumbertext"
    "--without-system-libpagemaker"
    "--without-system-libstaroffice"
    "--without-system-libqxp"
    "--without-system-dragonbox"
    "--without-system-libfixmath"
    "--without-system-hsqldb"
    "--without-system-zxing"
    "--without-system-zxcvbn"
    "--without-system-java-websocket"
    "--without-system-box2d"
    "--without-system-afdko"
  ]
  ++ optionals kdeIntegration [
    "--enable-kf6"
    "--enable-qt6"
  ]
  ++ optionals withJava [
    "--disable-scripting-javascript" # rhino gradle build broken

    "--with-system-beanshell"
    "--with-ant-home=${ant.home}"
    "--with-beanshell-jar=${bsh}"
  ];

  env = {
    NIX_CFLAGS_COMPILE = "-I${librdf_rasqal}/include/rasqal" + " -DSAL_LOG_WARN=1 -DSAL_LOG_INFO=1 ";

    FONTCONFIG_FILE = fontsConf;
  };

  makeFlags = [ "SHELL=${bash}/bin/bash" ];

  enableParallelBuilding = true;

  buildTargets = [ "build-nocheck" ];

  doCheck = false; # sdext_pdfimport test fails in sandbox

  preCheck = ''
    export HOME=$(pwd)
  '';

  checkTarget = concatStringsSep " " [
    "unitcheck"
    "slowcheck"
    "--keep-going"
  ];

  postInstall = ''
    mkdir -p $out/{include,share/icons}

    cp -r include/LibreOfficeKit $out/include/
    cp -r sysui/desktop/icons/hicolor $out/share/icons

    # Rename icons for consistency
    for file in $out/share/icons/hicolor/*/apps/*; do
      mv $file "$(dirname $file)/libreoffice-$(basename $file)"
    done

    ln -s $out/lib/libreoffice/share/xdg $out/share/applications

    # Unversionize desktop files
    . ./bin/get_config_variables PRODUCTVERSION
    for file in $out/lib/libreoffice/share/xdg/*.desktop; do
      substituteInPlace $file \
        --replace-fail "LibreOffice $PRODUCTVERSION" "LibreOffice" \
        --replace-warn "Icon=libreoffice$PRODUCTVERSION" "Icon=libreoffice" \
        --replace-fail "Exec=libreoffice$PRODUCTVERSION" "Exec=libreoffice"
    done
  '';

  dontWrapQtApps = true;

  __structuredAttrs = true;

  strictDeps = true;

  passthru = {
    inherit srcs;
    inherit withJava;
    jdk = if withJava then jre' else null;
    python = python3;
    inherit kdeIntegration;
    inherit gtk3;
    inherit (qt6) qtbase;
    gst_packages = with gstreamer.pkgs; [
      gst-libav
      gst-plugins-bad
      gst-plugins-base
      gst-plugins-good
      gst-plugins-ugly
      gstreamer.out
    ];
    qmlPackages = [
      kdePackages.ki18n
      kdePackages.knotifications
      qt6.qtdeclarative
      qt6.qtmultimedia
      qt6.qtwayland
      kdePackages.solid
      kdePackages.sonnet
    ];
    qtPackages = [
      kdePackages.kauth
      kdePackages.kcompletion
      kdePackages.kconfigwidgets
      kdePackages.kglobalaccel
      kdePackages.ki18n
      kdePackages.kio
      kdePackages.kitemviews
      kdePackages.ktextwidgets
      kdePackages.kwidgetsaddons
      kdePackages.kwindowsystem
      kdePackages.kxmlgui
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qtmultimedia
      qt6.qtsvg
      qt6.qttools
      qt6.qtwayland
      kdePackages.sonnet
    ];
  };

  disallowedRequisites = lib.optionals (!kdeIntegration) (
    lib.concatMap (x: lib.optional (x ? dev) x.dev) finalAttrs.buildInputs
  );

  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    changelog = "https://wiki.documentfoundation.org/ReleaseNotes/${lib.versions.majorMinor version}";
    description = "Comprehensive, professional-quality productivity suite, a variant of openoffice.org";
    homepage = "https://libreoffice.org/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = with lib.licenses; [
      mpl20
      lgpl3Plus
      asl20
    ];
    platforms = lib.platforms.linux;
    mainProgram = "libreoffice";
  };
})
