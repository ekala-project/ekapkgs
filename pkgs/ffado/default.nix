{
  lib,
  stdenv,
  argp-standalone,
  dbus,
  dbus_cplusplus,
  fetchurl,
  glibmm_2_4,
  libavc1394,
  libconfig,
  libiec61883,
  libraw1394,
  libxmlxx3,
  pkg-config,
  python3,
  scons,
  which,
  udevCheckHook,
  qt5,

  withMixer ? false,
}:

let
  python = python3.withPackages (
    pkgs:
    with pkgs;
    (
      [
        setuptools
      ]
      ++ lib.optionals withMixer [
        pyqt5
        dbus-python
      ]
    )
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ffado";
  version = "2.4.9";

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  src = fetchurl {
    url = "https://www.ffado.org/files/libffado-${finalAttrs.version}.tgz";
    hash = "sha256-xELFL60Ryv1VE7tOhGyFHxAchIT4karFRe0ZDo/U0Q8=";
  };

  prePatch = ''
    substituteInPlace ./support/tools/ffado-diag.in \
      --replace /lib/modules/ "/run/booted-system/kernel-modules/lib/modules/"

    # prevent build tools from leaking into closure
    substituteInPlace support/tools/SConscript --replace-fail \
      'support/tools/ffado-diag --static' \
      "echo '"'See `nix-store --query --tree $(out)`.'"'"

    # distutils was removed in python 3.12+, replace with sysconfig
    substituteInPlace SConstruct \
      --replace-fail 'import distutils.sysconfig' 'import sysconfig' \
      --replace-fail 'distutils.sysconfig' 'sysconfig' \
      --replace-fail 'get_python_lib()' "get_path('purelib')"
  ''
  + lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # skip the CC sanity check, since that requires invoking cross-compiled binaries during build
    substituteInPlace SConstruct \
      --replace-fail 'conf.CompilerCheck()' 'True' \
      --replace-fail "pkg-config" "$PKG_CONFIG"
    substituteInPlace admin/pkgconfig.py \
      --replace-fail "pkg-config" "$PKG_CONFIG"
  '';

  nativeBuildInputs = [
    scons
    pkg-config
    python
    which
    udevCheckHook
  ]
  ++ lib.optionals withMixer [
    python.pkgs.pyqt5
    qt5.wrapQtAppsHook
  ];

  prefixKey = "PREFIX=";
  sconsFlags = [
    "CUSTOM_ENV=True" # tell SConstruct to use nixpkgs' CC/CXX/CFLAGS
    "DETECT_USERSPACE_ENV=False"
    "DEBUG=False"
    "ENABLE_ALL=True"
    "BUILD_TESTS=True"
    "BUILD_MIXER=${if withMixer then "True" else "False"}"
    "UDEVDIR=$(out)/lib/udev/rules.d"
    "PYPKGDIR=$(out)/${python.sitePackages}"
    "BINDIR=$(bin)/bin"
    "INCLUDEDIR=$(dev)/include"
    "PYTHON_INTERPRETER=${python.interpreter}"
  ];

  buildInputs = [
    dbus
    dbus_cplusplus
    glibmm_2_4
    libavc1394
    libconfig
    libiec61883
    libraw1394
    libxmlxx3
    python
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isGnu) [
    argp-standalone
  ];

  env = lib.optionalAttrs (!stdenv.hostPlatform.isGnu) {
    NIX_LDFLAGS = "-largp";
  };

  dontWrapQtApps = true;
  strictDeps = true;
  doInstallCheck = true;

  preFixup = lib.optionalString withMixer ''
    wrapQtApp "$bin/bin/ffado-mixer"
  '';

  meta = {
    homepage = "http://www.ffado.org";
    description = "FireWire audio drivers";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
})
