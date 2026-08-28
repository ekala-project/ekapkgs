{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "orc";
  version = "0.4.41";

  outputs = [
    "out"
    "dev"
  ];
  outputBin = "dev";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/orc/orc-${finalAttrs.version}.tar.xz";
    hash = "sha256-yxv9T2VSic05vARkLVl76d5UJ2I/CGHB/BnAjZhGf6I=";
  };

  postPatch = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
    sed -i '/memcpy_speed/d' testsuite/meson.build
  '';

  mesonFlags = [
    "-Dgtk_doc=disabled"
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
  ];

  meta = {
    description = "Oil Runtime Compiler";
    homepage = "https://gstreamer.freedesktop.org/projects/orc.html";
    license = with lib.licenses; [
      bsd3
      bsd2
    ];
    platforms = lib.platforms.unix;
  };
})
