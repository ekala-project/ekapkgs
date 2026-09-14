{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wrapGAppsNoGuiHook
, gobject-introspection
, glib
, systemd
, udev
, libevdev
, gitMinimal
, swig
, python3
, json-glib
, libunistring
,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libratbag";
  version = "0.18";

  src = fetchFromGitHub {
    owner = "libratbag";
    repo = "libratbag";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dAWKDF5hegvKhUZ4JW2J/P9uSs4xNrZLNinhAff6NSc=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gitMinimal
    swig
    wrapGAppsNoGuiHook
    gobject-introspection
  ];

  buildInputs = [
    glib
    systemd
    udev
    libevdev
    json-glib
    libunistring
    (python3.withPackages (
      ps: with ps; [
        evdev
        pygobject3
      ]
    ))
  ];

  mesonFlags = [
    "-Dsystemd-unit-dir=./lib/systemd/system/"
    "-Dtests=false"
  ];

  meta = {
    description = "Configuration library for gaming mice";
    homepage = "https://github.com/libratbag/libratbag";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
