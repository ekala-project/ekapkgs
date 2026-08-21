{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,

  # nativeBuildInputs
  scons,
  pkg-config,

  # buildInputs
  dbus,
  libusb1,
  ncurses,
  kppsSupport ? stdenv.hostPlatform.isLinux,
  pps-tools,
  python3Packages,

  # optional deps for GUI packages
  guiSupport ? false,
  dbus-glib,
  libX11,
  libXt,
  libXpm,
  libXaw,
  libXext,
  gobject-introspection,
  pango,
  gdk-pixbuf,
  atk,
  wrapGAppsHook3,

  gpsdUser ? "gpsd",
  gpsdGroup ? "dialout",
}:

stdenv.mkDerivation rec {
  pname = "gpsd";
  version = "3.25";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-s2i2owXj96Y4LSOgy/wdeJIwYLa39Uz3mHpzx7Spr8I=";
  };

  nativeBuildInputs = [
    pkg-config
    python3Packages.wrapPython
    scons
  ]
  ++ lib.optionals guiSupport [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus
    libusb1
    ncurses
    python3Packages.python
  ]
  ++ lib.optionals kppsSupport [
    pps-tools
  ]
  ++ lib.optionals guiSupport [
    atk
    dbus-glib
    gdk-pixbuf
    libX11
    libXaw
    libXext
    libXpm
    libXt
    pango
  ];

  pythonPath = lib.optionals guiSupport [
    python3Packages.pygobject3
    python3Packages.pycairo
  ];

  patches = [
    ./sconstruct-env-fixes.patch
    ./sconstrict-rundir-fixes.patch

    # fix build with Python 3.12
    (fetchpatch {
      url = "https://gitlab.com/gpsd/gpsd/-/commit/9157b1282d392b2cc220bafa44b656d6dac311df.patch";
      hash = "sha256-kFMn4HgidQvHwHfcSNH/0g6i1mgvEnZfvAUDPU4gljg=";
    })
  ];

  preBuild = ''
    patchShebangs .
    sed -e "s|systemd_dir = .*|systemd_dir = '$out/lib/systemd/system'|" -i SConscript
    export TAR=noop
    substituteInPlace SConscript --replace "env['CCVERSION']" "env['CC']"
  '';

  sconsFlags = [
    "leapfetch=no"
    "gpsd_user=${gpsdUser}"
    "gpsd_group=${gpsdGroup}"
    "systemd=yes"
    "xgps=${if guiSupport then "True" else "False"}"
    "udevdir=${placeholder "out"}/lib/udev"
    "python_libdir=${placeholder "out"}/${python3Packages.python.sitePackages}"
  ];

  preCheck = ''
    export LD_LIBRARY_PATH="$PWD"
  '';

  preInstall = ''
    mkdir -p "$out/lib/udev/rules.d"
  '';

  installTargets = [
    "install"
    "udev-install"
  ];

  postFixup = ''
    wrapPythonProgramsIn $out/bin "$out $pythonPath"
  '';

  meta = {
    description = "GPS service daemon";
    homepage = "https://gpsd.gitlab.io/gpsd/index.html";
    changelog = "https://gitlab.com/gpsd/gpsd/-/blob/release-${version}/NEWS";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
