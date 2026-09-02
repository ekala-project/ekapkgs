{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pkg-config,
  python3,
  python3Packages ? { },
  libevdev ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "evemu";
  version = "2.7.0";

  src = fetchgit {
    url = "git://git.freedesktop.org/git/evemu";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-SQDaARuqBMBVlUz+Nw6mjdxaZfVOukmzTlIqy8U2rus=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    python3
  ];

  buildInputs = [
    libevdev
  ]
  ++ lib.optionals (python3Packages ? evdev) [
    python3Packages.evdev
  ];

  strictDeps = true;

  meta = {
    description = "Records and replays device descriptions and events to emulate input devices through the kernel's input system";
    homepage = "https://www.freedesktop.org/wiki/Evemu/";
    license = with lib.licenses; [
      lgpl3Only
      gpl3Only
    ];
    platforms = lib.platforms.linux;
  };
})
