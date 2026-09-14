{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  pkg-config,
  cmake,
  extra-cmake-modules,
  wayland-scanner,
  cairo,
  pango,
  expat,
  fribidi,
  wayland,
  systemd,
  wayland-protocols,
  plasma-wayland-protocols,
  nlohmann_json,
  isocodes,
  xkeyboard-config,
  enchant,
  gdk-pixbuf,
  libGL,
  libuuid,
  libselinux,
  libxdmcp,
  libsepol,
  libxkbcommon,
  libthai,
  libdatrie,
  libxcb-keysyms,
  libxcb-util,
  libxcb-wm,
  xcb-imdkit,
  libxkbfile,
  fmt,
  json_c,
  gettext,
}:
let
  enDictVer = "20121020";
  enDict = fetchurl {
    url = "https://download.fcitx-im.org/data/en_dict-${enDictVer}.tar.gz";
    hash = "sha256-xEpdeEeSXuqeTS0EdI1ELNKN2SmaC1cu99kerE9abOs=";
  };
in
stdenv.mkDerivation rec {
  pname = "fcitx5";
  version = "5.1.15";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-g9qDdDx+y/Vmky3pjlG77wsVERWB7ZpnDw+edhYw9Ss=";
    fetchSubmodules = true;
  };

  prePatch = ''
    ln -s ${enDict} src/modules/spell/$(stripHash ${enDict})
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    wayland-scanner
    gettext
  ];

  buildInputs = [
    plasma-wayland-protocols
    extra-cmake-modules
    expat
    isocodes
    cairo
    enchant
    pango
    libthai
    libdatrie
    fribidi
    systemd
    gdk-pixbuf
    wayland
    wayland-protocols
    nlohmann_json
    libGL
    libuuid
    libselinux
    libsepol
    libxdmcp
    libxkbcommon
    libxcb-util
    libxcb-wm
    libxcb-keysyms
    xcb-imdkit
    xkeyboard-config
    libxkbfile
    fmt
    json_c
  ];

  strictDeps = true;

  meta = {
    description = "Next generation of fcitx";
    homepage = "https://github.com/fcitx/fcitx5";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "fcitx5";
    platforms = lib.platforms.linux;
  };
}
