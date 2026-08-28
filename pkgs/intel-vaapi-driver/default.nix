{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gnum4,
  pkg-config,
  python3,
  wayland-scanner,
  libdrm,
  libva,
  libx11,
  libGL,
  wayland,
  libxext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "intel-vaapi-driver";
  version = "2.4.5";

  src = fetchFromGitHub {
    owner = "irql-notlessorequal";
    repo = "intel-vaapi-driver";
    tag = finalAttrs.version;
    hash = "sha256-exQBA42jCmwybE7WIfF83cjmzBdtluDzUtOdqt49HSg=";
  };

  env.LIBVA_DRIVERS_PATH = "${placeholder "out"}/lib/dri";

  configureFlags = [
    "--enable-x11"
    "--enable-wayland"
  ];

  nativeBuildInputs = [
    autoreconfHook
    gnum4
    pkg-config
    python3
    wayland-scanner
  ];

  buildInputs = [
    libdrm
    libva
    libx11
    libxext
    libGL
    wayland
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/irql-notlessorequal/intel-vaapi-driver";
    license = lib.licenses.mit;
    description = "VA-API user mode driver for Intel GEN Graphics family";
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
})
