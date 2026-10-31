{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  cmake,
  pkg-config,
  kdePackages,
  boost,
  gettext,
  libime,
  fcitx5,
  fcitx5-qt,
  opencc,
  curl,
  fmt,
  qt6,
  nlohmann_json,
}:

let
  pyStrokeVer = "20250329";
  pyStroke = fetchurl {
    url = "http://download.fcitx-im.org/data/py_stroke-${pyStrokeVer}.tar.gz";
    hash = "sha256-wafKciXTYUq4M1P8gnUDAGqYBEd2IBj1N2BCXXtTA6Y=";
  };
  pyTableVer = "20121124";
  pyTable = fetchurl {
    url = "http://download.fcitx-im.org/data/py_table-${pyTableVer}.tar.gz";
    hash = "sha256-QhRqyX3mwT1V+eme2HORX0xmc56cEVMqNFVrrfl5LAQ=";
  };
in

stdenv.mkDerivation rec {
  pname = "fcitx5-chinese-addons";
  version = "5.1.14";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-EtAoUoZQqxb049oD7r/UgdpJdS/kenMn3t1SHv+YIkg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    gettext
  ];

  prePatch = ''
    ln -s ${pyStroke} modules/pinyinhelper/$(stripHash ${pyStroke})
    ln -s ${pyTable} modules/pinyinhelper/$(stripHash ${pyTable})
  '';

  buildInputs = [
    boost
    fcitx5
    fcitx5-qt
    libime
    curl
    opencc
    qt6.qtwebengine
    fmt
    qt6.qtbase
    nlohmann_json
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Addons related to Chinese, including IME previous bundled inside fcitx4";
    mainProgram = "scel2org5";
    homepage = "https://github.com/fcitx/fcitx5-chinese-addons";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
