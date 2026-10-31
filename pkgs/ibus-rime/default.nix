{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  gdk-pixbuf,
  glib,
  ibus,
  libnotify,
  librime,
  pkg-config,
  rime-data,
  symlinkJoin,
  rimeDataPkgs ? [ rime-data ],
}:

stdenv.mkDerivation rec {
  pname = "ibus-rime";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "ibus-rime";
    rev = version;
    sha256 = "sha256-7RyCJpgGMqq5s4ijTDA2aq2CtpnQ1HOwO9aPrizSaSo=";
  };

  buildInputs = [
    gdk-pixbuf
    glib
    ibus
    libnotify
    librime
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
  ];

  cmakeEntries = {
    RIME_DATA_DIR = "${placeholder "out"}/share/rime-data";
  };

  rimeDataDrv = symlinkJoin {
    name = "ibus-rime-data";
    paths = rimeDataPkgs;
    postBuild = ''
      mkdir -p $out/share/rime-data
      [ -e "$out/share/rime-data/default.yaml" ] || touch "$out/share/rime-data/default.yaml"
    '';
  };

  postInstall = ''
    cp -r "${rimeDataDrv}/share/rime-data/." $out/share/rime-data/
  '';

  meta = {
    isIbusEngine = true;
    description = "Rime input method engine for IBus";
    homepage = "https://rime.im/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
