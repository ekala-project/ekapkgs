{
  lib,
  stdenv,
  replaceVars,
  fetchFromGitHub,
  autoreconfHook,
  gettext,
  makeWrapper,
  pkg-config,
  vala,
  dbus,
  systemd,
  dconf,
  glib,
  gdk-pixbuf,
  gobject-introspection,
  gtk3,
  gtk4,
  gtk-doc,
  libdbusmenu-gtk3,
  runCommand,
  isocodes,
  cldr-annotations,
  unicode-character-database,
  unicode-emoji,
  python3,
  json-glib,
  libnotify,
  libxkbcommon,
  wayland,
  wayland-protocols,
  wayland-scanner,
  buildPackages,
  runtimeShell,
  libx11,
}:

let
  python3Runtime = python3.withPackages (ps: [ ps.pygobject3 ]);
  python3BuildEnv = python3.pythonOnBuildForHost.buildEnv.override {
    postBuild = ''
      makeWrapper ${glib.dev}/bin/gdbus-codegen $out/bin/gdbus-codegen --unset PYTHONPATH
      makeWrapper ${glib.dev}/bin/glib-genmarshal $out/bin/glib-genmarshal --unset PYTHONPATH
      makeWrapper ${glib.dev}/bin/glib-mkenums $out/bin/glib-mkenums --unset PYTHONPATH
    '';
  };
  dbus-launch =
    runCommand "sandbox-dbus-launch"
      { nativeBuildInputs = [ makeWrapper ]; }
      ''
        makeWrapper ${dbus}/bin/dbus-launch $out/bin/dbus-launch \
          --add-flags --config-file=${dbus}/share/dbus-1/session.conf
      '';
in

stdenv.mkDerivation (finalAttrs: {
  pname = "ibus";
  version = "1.5.34";

  src = fetchFromGitHub {
    owner = "ibus";
    repo = "ibus";
    tag = finalAttrs.version;
    hash = "sha256-MCxzMnG+g2FC4pZtDOP2c7vSRG5Zk6EfrkGnEyFvBfQ=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      pythonInterpreter = python3Runtime.interpreter;
      pythonSitePackages = python3.sitePackages;
      prefix = null;
      datarootdir = null;
      localedir = null;
      PYTHON = null;
    })
    ./build-without-dbus-launch.patch
  ];

  outputs = [
    "out"
    "dev"
    "installedTests"
  ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace "m4_define([ibus_released], [0])" "m4_define([ibus_released], [1])"

    patchShebangs --build data/dconf/make-dconf-override-db.sh
    cp ${buildPackages.gtk-doc}/share/gtk-doc/data/gtk-doc.make .
    substituteInPlace bus/services/org.freedesktop.IBus.session.GNOME.service.in \
      --replace "ExecStart=sh" "ExecStart=${runtimeShell}"
    substituteInPlace bus/services/org.freedesktop.IBus.session.generic.service.in \
      --replace "ExecStart=sh" "ExecStart=${runtimeShell}"
  '';

  preAutoreconf = "touch ChangeLog";

  configureFlags = [
    "CC_FOR_BUILD=${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc"
    "CXX_FOR_BUILD=${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}c++"
    "GLIB_COMPILE_RESOURCES=${lib.getDev buildPackages.glib}/bin/glib-compile-resources"
    "PKG_CONFIG_VAPIGEN_VAPIGEN=${lib.getBin buildPackages.vala}/bin/vapigen"
    "--disable-memconf"
    "--disable-gtk2"
    "--with-python=${python3BuildEnv.interpreter}"
    "--enable-dconf"
    "--enable-libnotify"
    "--enable-wayland"
    "--enable-ui"
    "--enable-gtk3"
    "--enable-gtk4"
    "--enable-xim"
    "--enable-appindicator"
    "--enable-tests"
    "--enable-install-tests"
    "--enable-emoji-dict"
    "--enable-unicode-dict"
    "--with-unicode-emoji-dir=${unicode-emoji}/share/unicode/emoji"
    "--with-emoji-annotation-dir=${cldr-annotations}/share/unicode/cldr/common/annotations"
    "--with-ucd-dir=${unicode-character-database}/share/unicode"
  ];

  makeFlags = [
    "test_execsdir=${placeholder "installedTests"}/libexec/installed-tests/ibus"
    "test_sourcesdir=${placeholder "installedTests"}/share/installed-tests/ibus"
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    autoreconfHook
    gtk-doc
    gettext
    makeWrapper
    pkg-config
    python3BuildEnv
    dbus-launch
    glib
    vala
    gobject-introspection
    gtk3.wrapGAppsHook
    wayland-scanner
  ];

  propagatedBuildInputs = [
    glib
  ];

  buildInputs = [
    dbus
    systemd
    dconf
    python3.pkgs.pygobject3
    isocodes
    json-glib
    libx11
    vala
    gtk3
    gtk4
    gdk-pixbuf
    libdbusmenu-gtk3
    libnotify
    libxkbcommon
    wayland
    wayland-protocols
    wayland-scanner
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  doCheck = false;

  postInstall = ''
    moveToOutput "bin/ibus-desktop-testing-runner" "$installedTests"
  '';

  postFixup = ''
    for f in $installedTests/libexec/installed-tests/ibus/*; do
        wrapGApp $f
    done
  '';

  meta = {
    description = "Intelligent Input Bus, input method framework";
    homepage = "https://github.com/ibus/ibus";
    changelog = "https://github.com/ibus/ibus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    mainProgram = "ibus";
  };
})
