{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  perl,
  doxygen,
  libjpeg,
  json_c,
  udev,
  withUtils ? true,
  withGUI ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "v4l-utils";
  version = "1.32.0";

  src = fetchurl {
    url = "https://linuxtv.org/downloads/v4l-utils/v4l-utils-${finalAttrs.version}.tar.xz";
    hash = "sha256-aCiCihd3VSbrk/slipKU0dEHPWM8NE3XHs1Oeh/7ffw=";
  };

  outputs = [
    "out"
  ]
  ++ lib.optional withUtils "lib"
  ++ [
    "dev"
  ];

  mesonEntries = {
    v4l-utils = withUtils;
    udevdir = "${placeholder "out"}/lib/udev";
  };

  mesonFeatures = {
    gconv = false;
    qv4l2 = false;
    qvidcap = false;
    bpf = false;
  };

  nativeBuildInputs = [
    doxygen
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    perl
  ];

  buildInputs = [
    json_c
    udev
  ];

  propagatedBuildInputs = [ libjpeg ];

  postPatch = ''
    patchShebangs utils/
  '';

  postFixup = ''
    # Create symlink for V4l1 compatibility
    ln -s "$dev/include/libv4l1-videodev.h" "$dev/include/videodev.h"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "V4L utils and libv4l, provide common image formats regardless of the v4l device";
    homepage = "https://linuxtv.org/projects.php";
    license = with lib.licenses; [
      lgpl21Plus
      gpl2Plus
    ];
    platforms = lib.platforms.linux;
  };
})
