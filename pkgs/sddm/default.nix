{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  runCommand,
  cmake,
  pkg-config,
  qttools,
  libxcb,
  libxau,
  linux-pam,
  qtbase,
  qtdeclarative,
  qtquickcontrols2 ? null,
  systemd,
  xkeyboard-config,
  docutils,
  wrapQtAppsHook,
  extraPackages ? [ ],
}:

let
  isQt6 = lib.versions.major qtbase.version == "6";

  unwrapped = stdenv.mkDerivation (finalAttrs: {
    pname = "sddm-unwrapped";
    version = "0.21.0";

    src = fetchFromGitHub {
      owner = "sddm";
      repo = "sddm";
      rev = "v${finalAttrs.version}";
      hash = "sha256-r5mnEWham2WnoEqRh5tBj/6rn5mN62ENOCmsLv2Ht+w=";
    };

    outputs = [
      "out"
      "man"
    ];

    patches = [
      ./greeter-path.patch
      ./sddm-ignore-config-mtime.patch
      ./sddm-default-session.patch

      (fetchpatch {
        name = "sddm-fix-cmake-4.patch";
        url = "https://github.com/sddm/sddm/commit/228778c2b4b7e26db1e1d69fe484ed75c5791c3a.patch";
        hash = "sha256-Okt9LeZBhTDhP7NKBexWAZhkK6N6j9dFkAEgpidSnzE=";
      })
    ];

    postPatch = ''
      substituteInPlace src/greeter/waylandkeyboardbackend.cpp \
        --replace "/usr/share/X11/xkb/rules/evdev.xml" "${xkeyboard-config}/share/X11/xkb/rules/evdev.xml"
    '';

    nativeBuildInputs = [
      cmake
      pkg-config
      qttools
      docutils
    ];

    buildInputs = [
      libxcb
      libxau
      linux-pam
      qtbase
      qtdeclarative
      qtquickcontrols2
      systemd
    ];

    dontWrapQtApps = true;

    cmakeFlags = [
      (lib.cmakeBool "BUILD_WITH_QT6" isQt6)
      (lib.cmakeBool "BUILD_MAN_PAGES" true)
      "-DCONFIG_FILE=/etc/sddm.conf"
      "-DCONFIG_DIR=/etc/sddm.conf.d"
      "-DUID_MIN=1000"
      "-DUID_MAX=29999"
      "-DSDDM_INITIAL_VT=1"
      "-DQT_IMPORTS_DIR=${placeholder "out"}/${qtbase.qtQmlPrefix}"
      "-DCMAKE_INSTALL_SYSCONFDIR=${placeholder "out"}/etc"
      "-DSYSTEMD_SYSTEM_UNIT_DIR=${placeholder "out"}/lib/systemd/system"
      "-DSYSTEMD_SYSUSERS_DIR=${placeholder "out"}/lib/sysusers.d"
      "-DSYSTEMD_TMPFILES_DIR=${placeholder "out"}/lib/tmpfiles.d"
      "-DDBUS_CONFIG_DIR=${placeholder "out"}/share/dbus-1/system.d"
    ];

    postInstall = ''
      rm "$out/share/sddm/scripts/Xsetup" "$out/share/sddm/scripts/Xstop"
      for f in $out/share/sddm/themes/**/theme.conf ; do
        substituteInPlace $f \
          --replace 'background=' "background=$(dirname $f)/"
      done
    '';

    meta = {
      description = "QML based X11 and Wayland display manager";
      homepage = "https://github.com/sddm/sddm";
      platforms = lib.platforms.linux;
      license = lib.licenses.gpl2Plus;
    };
  });
in
runCommand "sddm-wrapped"
  {
    pname = "sddm";
    inherit (unwrapped) version;
    outputs = [
      "out"
      "man"
    ];

    buildInputs = unwrapped.buildInputs ++ extraPackages;
    nativeBuildInputs = [ wrapQtAppsHook ];

    strictDeps = true;

    passthru = {
      inherit unwrapped;
    };

    meta = unwrapped.meta;
  }
  ''
    mkdir -p $out/bin

    cd ${unwrapped}

    for i in *; do
      if [ "$i" == "bin" ]; then
        continue
      fi
      ln -s ${unwrapped}/$i $out/$i
    done

    for i in bin/*; do
      makeQtWrapper ${unwrapped}/$i $out/$i --set SDDM_GREETER_DIR $out/bin
    done

    mkdir -p $man
    ln -s ${lib.getMan unwrapped}/* $man/
  ''
