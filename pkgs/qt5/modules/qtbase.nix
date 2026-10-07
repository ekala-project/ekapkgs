{
  stdenv,
  lib,
  src,
  patches,
  version,
  qtCompatVersion,

  coreutils,
  bison,
  flex,
  gdb,
  gperf,
  lndir,
  perl,
  pkg-config,
  python3,
  copyPathToStore,
  makeSetupHook,
  which,

  dbus,
  fontconfig,
  freetype,
  glib,
  harfbuzz,
  icu,
  libdrm,
  libx11,
  libxcomposite,
  libxcursor,
  libxext,
  libxi,
  libxrender,
  libjpeg,
  libpng,
  libxcb,
  libxkbcommon,
  libxml2,
  libxslt,
  openssl,
  pcre2,
  sqlite,
  udev,
  libxcb-util,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-wm,
  zlib,
  at-spi2-core,

  # optional dependencies
  cups ? null,
  libpq ? null,
  withGtk3 ? false,
  dconf,
  gtk3,
  qttranslations ? null,
  withLibinput ? false,
  libinput,

  # options
  libGLSupported ? true,
  libGL,
  mysqlSupport ? true,
  mariadb-connector-c,
  buildExamples ? false,
  buildTests ? false,
  debug ? false,
  developerBuild ? false,
  decryptSslTraffic ? false,
  testers,
}:

let
  debugSymbols = debug || developerBuild;
  qtPluginPrefix = "lib/qt-${qtCompatVersion}/plugins";
  qtQmlPrefix = "lib/qt-${qtCompatVersion}/qml";
  qtDocPrefix = "share/doc/qt-${qtCompatVersion}";
  fix_qt_builtin_paths = copyPathToStore ../hooks/fix-qt-builtin-paths.sh;
  fix_qt_module_paths = copyPathToStore ../hooks/fix-qt-module-paths.sh;

  devTools = [
    "bin/fixqt4headers.pl"
    "bin/moc"
    "bin/qdbuscpp2xml"
    "bin/qdbusxml2cpp"
    "bin/qlalr"
    "bin/qmake"
    "bin/rcc"
    "bin/syncqt.pl"
    "bin/uic"
  ];
in

stdenv.mkDerivation (finalAttrs: {
  pname = "qtbase";
  inherit qtCompatVersion src version;

  propagatedBuildInputs = [
    libxml2
    libxslt
    openssl
    sqlite
    zlib

    # Text rendering
    freetype
    harfbuzz
    icu

    # Image formats
    libjpeg
    libpng
    pcre2

    dbus
    glib
    udev

    # Text rendering
    fontconfig

    libdrm

    # X11 libs
    libx11
    libxcomposite
    libxext
    libxi
    libxrender
    libxcb
    libxkbcommon
    libxcb-util
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm
  ]
  ++ lib.optionals libGLSupported [
    libGL
  ];

  buildInputs = [
    python3
    at-spi2-core
  ]
  ++ lib.optional withLibinput libinput
  ++ lib.optional withGtk3 gtk3
  ++ lib.optionals developerBuild [
    gdb
  ]
  ++ lib.optionals (cups != null) [
    cups
  ]
  ++ lib.optionals mysqlSupport [
    mariadb-connector-c
  ]
  ++ lib.optionals (libpq != null) [
    libpq
  ];

  nativeBuildInputs = [
    bison
    flex
    gperf
    lndir
    perl
    pkg-config
    which
  ]
  ++ lib.optionals mysqlSupport [
    mariadb-connector-c
  ];

  propagatedNativeBuildInputs = [ lndir ];

  strictDeps = true;


  outputs = [
    "bin"
    "dev"
    "out"
  ];

  inherit patches;

  preHook = ''
    . ${fix_qt_builtin_paths}
    . ${fix_qt_module_paths}
    . ${../hooks/move-qt-dev-tools.sh}
    . ${../hooks/fix-qmake-libtool.sh}
  '';

  postPatch = ''
    for prf in qml_plugin.prf qt_plugin.prf qt_docs.prf qml_module.prf create_cmake.prf; do
        substituteInPlace "mkspecs/features/$prf" \
            --subst-var-by qtPluginPrefix ${qtPluginPrefix} \
            --subst-var-by qtQmlPrefix ${qtQmlPrefix} \
            --subst-var-by qtDocPrefix ${qtDocPrefix}
    done

    substituteInPlace configure --replace-fail /bin/pwd pwd
    substituteInPlace src/corelib/global/global.pri --replace-fail /bin/ls ${coreutils}/bin/ls
    sed -e 's@/\(usr\|opt\)/@/var/empty/@g' -i mkspecs/*/*.conf

    sed -i '/PATHS.*NO_DEFAULT_PATH/ d' src/corelib/Qt5Config.cmake.in
    sed -i '/PATHS.*NO_DEFAULT_PATH/ d' src/corelib/Qt5CoreMacros.cmake
    sed -i 's/NO_DEFAULT_PATH//' src/gui/Qt5GuiConfigExtras.cmake.in
    sed -i '/PATHS.*NO_DEFAULT_PATH/ d' mkspecs/features/data/cmake/Qt5BasicConfig.cmake.in

    # https://bugs.gentoo.org/803470
    sed -i 's/-lpthread/-pthread/' mkspecs/common/linux.conf src/corelib/configure.json

    patchShebangs ./bin
  ''
  + lib.optionalString libGLSupported ''
    sed -i mkspecs/common/linux.conf \
        -e "/^QMAKE_INCDIR_OPENGL/ s|$|${lib.getDev libGL}/include|" \
        -e "/^QMAKE_LIBDIR_OPENGL/ s|$|${lib.getLib libGL}/lib|"
  ''
  + lib.optionalString (stdenv.hostPlatform.isx86_32 && stdenv.cc.isGNU) ''
    sed -i mkspecs/common/gcc-base-unix.conf \
        -e "/^QMAKE_LFLAGS_SHLIB/ s/-shared/-shared -static-libgcc/"
  '';

  setOutputFlags = false;
  preConfigure = ''
    export LD_LIBRARY_PATH="$PWD/lib:$PWD/plugins/platforms''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"

    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QT_PLUGIN_PREFIX=\"${qtPluginPrefix}\""

    # paralellize compilation of qtmake, which happens within ./configure
    export MAKEFLAGS+=" -j$NIX_BUILD_CORES"

    ./bin/syncqt.pl -version ${version}
  '';

  postConfigure = ''
    qmakeCacheInjectNixOutputs() {
        local cache="$1/.qmake.stash"
        echo "qmakeCacheInjectNixOutputs: $cache"
        if ! [ -f "$cache" ]; then
            echo >&2 "qmakeCacheInjectNixOutputs: WARNING: $cache does not exist"
        fi
        cat >>"$cache" <<EOF
    NIX_OUTPUT_BIN = $bin
    NIX_OUTPUT_DEV = $dev
    NIX_OUTPUT_OUT = $out
    NIX_OUTPUT_DOC = $dev/${qtDocPrefix}
    NIX_OUTPUT_QML = $bin/${qtQmlPrefix}
    NIX_OUTPUT_PLUGIN = $bin/${qtPluginPrefix}
    EOF
    }

    find . -name '.qmake.conf' | while read conf; do
        qmakeCacheInjectNixOutputs "$(dirname $conf)"
    done
  '';

  env = {
    NIX_CFLAGS_COMPILE = toString (
      [
        "-Wno-error=sign-compare" # freetype-2.5.4 changed signedness of some struct fields
      ]
      ++ [
        ''-DNIXPKGS_QTCOMPOSE="${libx11.out}/share/X11/locale"''
        ''-DLIBRESOLV_SO="${stdenv.cc.libc.out}/lib/libresolv"''
        ''-DNIXPKGS_LIBXCURSOR="${libxcursor.out}/lib/libXcursor"''
      ]
      ++ lib.optionals libGLSupported [
        ''-DNIXPKGS_MESA_GL="${libGL.out}/lib/libGL"''
      ]
      ++ [
        "-DUSE_X11"
      ]
      ++ lib.optionals withGtk3 [
        ''-DNIXPKGS_QGTK3_XDG_DATA_DIRS="${gtk3}/share/gsettings-schemas/${gtk3.name}"''
        ''-DNIXPKGS_QGTK3_GIO_EXTRA_MODULES="${dconf.lib}/lib/gio/modules"''
      ]
      ++ lib.optionals decryptSslTraffic [
        "-DQT_DECRYPT_SSL_TRAFFIC"
      ]
    );
  }
  // lib.optionalAttrs (libpq != null) {
    # PostgreSQL autodetection fails sporadically because Qt omits the "-lpq" flag
    # if dependency paths contain the string "pq", which can occur in the hash.
    # To prevent these failures, we need to override PostgreSQL detection.
    PSQL_LIBS = "-L${libpq}/lib -lpq";
  };

  prefixKey = "-prefix ";

  # TODO Remove obsolete and useless flags once the build will be totally mastered
  configureFlags = [
    "-plugindir"
    "${placeholder "out"}/${qtPluginPrefix}"
    "-qmldir"
    "${placeholder "out"}/${qtQmlPrefix}"
    "-docdir"
    "${placeholder "out"}/${qtDocPrefix}"

    "-verbose"
    "-confirm-license"
    "-opensource"

    "-release"
    "-shared"
    "-accessibility"
    "-optimized-qmake"
    # for separateDebugInfo
    "-no-strip"
    "-system-proxies"
    "-pkg-config"

    "-gui"
    "-widgets"
    "-opengl"
    "desktop"
    "-icu"
    "-L"
    "${icu.out}/lib"
    "-I"
    "${icu.dev}/include"
    "-pch"
  ]
  ++ lib.optionals debugSymbols [
    "-debug"
  ]
  ++ lib.optionals developerBuild [
    "-developer-build"
    "-no-warnings-are-errors"
  ]
  ++ (
    if (!stdenv.hostPlatform.isx86_64) then
      [
        "-no-sse2"
      ]
    else
      [
        "-sse2"
        "${lib.optionalString (!stdenv.hostPlatform.sse3Support) "-no"}-sse3"
        "${lib.optionalString (!stdenv.hostPlatform.ssse3Support) "-no"}-ssse3"
        "${lib.optionalString (!stdenv.hostPlatform.sse4_1Support) "-no"}-sse4.1"
        "${lib.optionalString (!stdenv.hostPlatform.sse4_2Support) "-no"}-sse4.2"
        "${lib.optionalString (!stdenv.hostPlatform.avxSupport) "-no"}-avx"
        "${lib.optionalString (!stdenv.hostPlatform.avx2Support) "-no"}-avx2"
      ]
  )
  ++ [
    "-no-mips_dsp"
    "-no-mips_dspr2"
  ]
  ++ [
    "-system-zlib"
    "-L"
    "${zlib.out}/lib"
    "-I"
    "${zlib.dev}/include"
    "-system-libjpeg"
    "-L"
    "${libjpeg.out}/lib"
    "-I"
    "${libjpeg.dev}/include"
    "-system-harfbuzz"
    "-L"
    "${harfbuzz.out}/lib"
    "-I"
    "${harfbuzz.dev}/include"
    "-system-pcre"
    "-openssl-linked"
    "-L"
    "${lib.getLib openssl}/lib"
    "-I"
    "${openssl.dev}/include"
    "-system-sqlite"
    "-${if mysqlSupport then "plugin" else "no"}-sql-mysql"
    "-${if libpq != null then "plugin" else "no"}-sql-psql"
    "-system-libpng"

    "-make"
    "libs"
    "-make"
    "tools"
    "-${lib.optionalString (!buildExamples) "no"}make"
    "examples"
    "-${lib.optionalString (!buildTests) "no"}make"
    "tests"

    "-rpath"
    "-xcb"
    "-qpa"
    "xcb"
    "-L"
    "${libx11.out}/lib"
    "-I"
    "${libx11.out}/include"
    "-L"
    "${libxext.out}/lib"
    "-I"
    "${libxext.out}/include"
    "-L"
    "${libxrender.out}/lib"
    "-I"
    "${libxrender.out}/include"

    "-${lib.optionalString (cups == null) "no-"}cups"
    "-dbus-linked"
    "-glib"
  ]
  ++ lib.optionals withGtk3 [
    "-gtk"
  ]
  ++ lib.optionals withLibinput [
    "-libinput"
  ]
  ++ [
    "-inotify"
  ]
  ++ lib.optionals (cups != null) [
    "-L"
    "${cups.lib}/lib"
    "-I"
    "${cups.dev}/include"
  ]
  ++ lib.optionals (qttranslations != null) [
    "-translationdir"
    "${qttranslations}/translations"
  ];

  # Move selected outputs.
  postInstall = ''
    moveToOutput "mkspecs" "$dev"
  '';

  postFixup = ''
    # Don't retain build-time dependencies like gdb.
    sed '/QMAKE_DEFAULT_.*DIRS/ d' -i $dev/mkspecs/qconfig.pri
    fixQtModulePaths "''${!outputDev}/mkspecs/modules"
    fixQtBuiltinPaths "''${!outputDev}" '*.pr?'

    # Move development tools to $dev
    devTools="${lib.concatStringsSep " " devTools}"
    moveQtDevTools
    moveToOutput bin "$dev"

    # fixup .pc file (where to find 'moc' etc.)
    sed -i "$dev/lib/pkgconfig/Qt5Core.pc" \
      -e "/^host_bins=/ c host_bins=$dev/bin"
  '';

  dontStrip = debugSymbols;

  setupHook =
    let
      hook = makeSetupHook {
        name = "qtbase5-setup-hook";
        substitutions = {
          inherit
            qtPluginPrefix
            qtQmlPrefix
            qtDocPrefix
            fix_qt_builtin_paths
            fix_qt_module_paths
            ;
          debug = debugSymbols;
        };
        meta.license = lib.licenses.mit;
      } ../hooks/qtbase-setup-hook.sh;
    in
    "${hook}/nix-support/setup-hook";

  passthru = {
    inherit
      qtPluginPrefix
      qtQmlPrefix
      qtDocPrefix
      ;
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  __structuredAttrs = true;

  meta = {
    homepage = "https://www.qt.io/";
    description = "Cross-platform application framework for C++";
    license = with lib.licenses; [
      fdl13Plus
      gpl2Plus
      lgpl21Plus
      lgpl3Plus
    ];
    pkgConfigModules = [
      "Qt5Concurrent"
      "Qt5Core"
      "Qt5DBus"
      "Qt5Gui"
      "Qt5Network"
      "Qt5OpenGL"
      "Qt5OpenGLExtensions"
      "Qt5PrintSupport"
      "Qt5Sql"
      "Qt5Test"
      "Qt5Widgets"
      "Qt5Xml"
    ];
    platforms = lib.platforms.linux;
  };

})
