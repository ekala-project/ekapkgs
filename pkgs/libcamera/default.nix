{
  stdenv,
  fetchgit,
  lib,
  meson,
  ninja,
  pkg-config,
  makeFontsConf,
  openssl,
  libdrm,
  libevent,
  libyaml,
  gst_all_1,
  gtest,
  graphviz,
  doxygen,
  python3,
  python3Packages,
  udev,
  libpisp,
}:

stdenv.mkDerivation rec {
  pname = "libcamera";
  version = "0.7.0";

  src = fetchgit {
    url = "https://git.libcamera.org/libcamera/libcamera.git";
    rev = "v${version}";
    hash = "sha256-W9pRE8/0Cf2EEP5bbvy4FsDSeKKSklfJb6T48ZN4dzE=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  postPatch = ''
    patchShebangs src/py/ utils/
  '';

  preBuild = ''
    ninja src/ipa-priv-key.pem
    install -D ${./ipa-priv-key.pem} src/ipa-priv-key.pem
  '';

  postFixup = ''
    ../src/ipa/ipa-sign-install.sh src/ipa-priv-key.pem $out/lib/libcamera/ipa/ipa_*.so
  '';

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    python3Packages.jinja2
    python3Packages.pyyaml
    python3Packages.ply
    python3Packages.sphinx
    graphviz
    doxygen
    openssl
  ];

  buildInputs = [
    openssl
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libevent
    libdrm
    udev
    python3Packages.pybind11
    libyaml
    gtest
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch [ libpisp ];

  mesonFlags = [
    "-Dv4l2=true"
    "-Dtracing=disabled"
    "-Dqcam=disabled"
    "-Dlibunwind=disabled"
    "-Dlc-compliance=disabled"
    "-Dwerror=false"
    "-Ddocumentation=disabled"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch [
    "-Drpi-awb-nn=disabled"
  ];

  env = {
    NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";
    FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };
  };

  meta = {
    description = "Open source camera stack and framework for Linux, Android, and ChromeOS";
    homepage = "https://libcamera.org";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
}
