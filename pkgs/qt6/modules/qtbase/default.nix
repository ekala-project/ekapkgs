{
  stdenv,
  lib,
  src,
  version,
  bison,
  flex,
  gperf,
  lndir,
  perl,
  pkg-config,
  copyPathToStore,
  makeSetupHook,
  which,
  cmake,
  ninja,
  libproxy,
  libxcb-cursor,
  libxtst,
  libxdmcp,
  zstd,
  double-conversion,
  util-linux,
  systemd,
  systemdSupport ? stdenv.hostPlatform.isLinux,
  libb2,
  md4c,
  mtdev,
  lksctp-tools,
  libselinux,
  libsepol,
  vulkan-headers,
  vulkan-loader,
  libthai,
  libdrm,
  libgbm,
  libdatrie,
  lttng-ust,
  libepoxy,
  dbus,
  fontconfig,
  freetype,
  glib,
  harfbuzz,
  icu,
  libx11,
  libxcomposite,
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
  unixodbc,
  libGL,
  # mingw
  pkgsBuildBuild,
  # optional dependencies
  cups,
  mariadb-connector-c,
  libpq,
  withGtk3 ? false,
  gtk3,
  withLibinput ? false,
  libinput,
  withWayland ? lib.meta.availableOn stdenv.hostPlatform wayland,
  wayland,
  wayland-scanner,
  # options
  qttranslations ? null,
  fetchpatch,
}:

let
  isCrossBuild = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  fix_qt_builtin_paths = copyPathToStore ../../hooks/fix-qt-builtin-paths.sh;
  fix_qt_module_paths = copyPathToStore ../../hooks/fix-qt-module-paths.sh;
  qtPluginPrefix = "lib/qt-6/plugins";
  qtQmlPrefix = "lib/qt-6/qml";
in
stdenv.mkDerivation {
  pname = "qtbase";

  inherit src version;

  propagatedBuildInputs = [
    libxml2
    libxslt
    openssl
    sqlite
    zlib
    libGL
    vulkan-headers
    vulkan-loader
    # Text rendering
    harfbuzz
    icu
    # Image formats
    libjpeg
    libpng
    pcre2
    zstd
    libb2
    md4c
    double-conversion
  ]
  ++ [
    libproxy
    dbus
    glib
    # unixodbc
    unixodbc
  ]
  ++ lib.optionals systemdSupport [
    systemd
  ]
  ++ [
    util-linux
    mtdev
    lksctp-tools
    libselinux
    libsepol
    lttng-ust
    libthai
    libdrm
    libgbm
    libdatrie
    udev
    # Text rendering
    fontconfig
    freetype
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
    libxdmcp
    libxtst
    libxcb-cursor
    libepoxy
  ]
  ++ lib.optional (cups != null && lib.meta.availableOn stdenv.hostPlatform cups) cups
  ++ lib.optionals withWayland [
    wayland
    wayland-scanner
  ];

  buildInputs =
    lib.optionals (lib.meta.availableOn stdenv.hostPlatform at-spi2-core) [
      at-spi2-core
    ]
    ++ lib.optional withGtk3 gtk3
    ++ lib.optional withLibinput libinput
    ++ lib.optional (mariadb-connector-c != null) mariadb-connector-c
    ++ lib.optional (libpq != null && lib.meta.availableOn stdenv.hostPlatform libpq) libpq;

  nativeBuildInputs = [
    bison
    flex
    gperf
    lndir
    perl
    pkg-config
    which
    cmake
    cmake.configurePhaseHook
    ninja
  ];

  propagatedNativeBuildInputs = [
    lndir
  ]
  # wayland-scanner needs to be propagated as both build
  # (for the wayland-scanner binary) and host (for the
  # actual wayland.xml protocol definition)
  ++ lib.optionals withWayland [
    wayland
    wayland-scanner
  ];

  strictDeps = true;


  patches = [
    # look for Qt plugins in directories on PATH
    ./derive-plugin-load-path-from-PATH.patch

    # allow translations to be found outside of install prefix, as is the case in our split builds
    ./allow-translations-outside-prefix.patch

    # make internal find_package calls between Qt components work with split builds
    ./use-cmake-path.patch

    # always link to libraries by name in qmake-generated build scripts
    ./qmake-always-use-libname.patch
    # always explicitly list includedir in qmake-generated pkg-config files
    ./qmake-fix-includedir.patch

    # don't generate SBOM files by default, they don't work with our split installs anyway
    ./no-sbom.patch

    # use cmake from PATH in qt-cmake wrapper, to avoid qtbase runtime-depending on cmake
    ./use-cmake-from-path.patch

    # macdeployqt fixes
    # get qmlimportscanner location from environment variable
    ./find-qmlimportscanner.patch
    # pass QML2_IMPORT_PATH from environment to qmlimportscanner
    ./qmlimportscanner-import-path.patch
    # don't pass qtbase's QML directory to qmlimportscanner if it's empty
    ./skip-missing-qml-directory.patch

    # another crash fix
    (fetchpatch {
      url = "https://github.com/qt/qtbase/commit/515cbbacfba9f4259c9c3b0714a31222c2b4c879.diff";
      hash = "sha256-93tzp4O7dZxRZv7ilN/gbQSVmaeOGmxpYgM7aomN0n8=";
    })
  ];

  preHook = ''
    . ${fix_qt_builtin_paths}
    . ${fix_qt_module_paths}
  '';

  cmakeEntries = {
    QT_EMBED_TOOLCHAIN_COMPILER = false;
    INSTALL_PLUGINSDIR = "${qtPluginPrefix}";
    INSTALL_QMLDIR = "${qtQmlPrefix}";
    QT_FEATURE_libproxy = true;
    QT_FEATURE_system_sqlite = true;
    QT_FEATURE_openssl_linked = true;
    QT_FEATURE_vulkan = true;
    CMAKE_SYSTEM_VERSION = "";
    QT_FEATURE_sctp = true;
    QT_FEATURE_journald = "${if systemdSupport then ";
  };

  cmakeFlags = [
      "--log-level=STATUS"
      ON"
      else
      "OFF"
      }"
    ] ++ lib.optionals isCrossBuild [
    "-DQT_HOST_PATH=${pkgsBuildBuild.qt6.qtbase}"
    "-DQt6HostInfo_DIR=${pkgsBuildBuild.qt6.qtbase}/lib/cmake/Qt6HostInfo"
  ] ++ lib.optional (
    qttranslations != null && !isCrossBuild
  ) "-DINSTALL_TRANSLATIONSDIR=${qttranslations}/translations";

  env.NIX_CFLAGS_COMPILE = "-DNIXPKGS_QT_PLUGIN_PREFIX=\"${qtPluginPrefix}\"";

  outputs = [ "out" ];
  separateDebugInfo = false;

  moveToDev = false;

  postFixup = ''
    fixQtModulePaths  "$out/mkspecs/modules"
    # fixQtBuiltinPaths reads qtPluginPrefix/qtQmlPrefix from the environment,
    # but the setup hook only exports them for downstream packages; without
    # them e.g. $$[QT_INSTALL_PLUGINS] in qt.prf is rewritten to "$out/"
    # instead of "$out/${qtPluginPrefix}", breaking static plugin linking.
    qtPluginPrefix=${qtPluginPrefix} qtQmlPrefix=${qtQmlPrefix} \
      fixQtBuiltinPaths "$out" '*.pr?'

    # @out@ would be automagically replaced inside makeSetupHook by the output of that derivation,
    # but we need it to be the output of this derivation.
    # Use a different placeholder and explicitly substitute this
    # to keep compatibility with __structuredAttrs and avoid substituteAll.
    substituteInPlace "$out/nix-support/setup-hook" \
      --replace-fail "@qtbaseOut@" $out

    # FIXME: not sure why this isn't added automatically?
    patchelf --add-rpath "${mariadb-connector-c}/lib/mariadb" $out/${qtPluginPrefix}/sqldrivers/libqsqlmysql.so
    patchelf --add-rpath "${vulkan-loader}/lib" --add-needed "libvulkan.so" $out/lib/libQt6Gui.so
  '';

  dontWrapQtApps = true;

  setupHook =
    let
      hook = makeSetupHook {
        name = "qtbase6-setup-hook";
        substitutions = {
          inherit
            fix_qt_builtin_paths
            fix_qt_module_paths
            qtPluginPrefix
            qtQmlPrefix
            ;
        };
        meta.license = lib.licenses.mit;
      } ../../hooks/qtbase-setup-hook.sh;
    in
    "${hook}/nix-support/setup-hook";

  passthru = {
    inherit qtPluginPrefix qtQmlPrefix;
  };

  meta = {
    homepage = "https://www.qt.io/";
    description = "Cross-platform application framework for C++";
    license = with lib.licenses; [
      fdl13Plus
      gpl2Plus
      lgpl21Plus
      lgpl3Plus
    ];
    platforms = lib.platforms.linux;
  };
}
