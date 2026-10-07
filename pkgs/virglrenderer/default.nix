{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  buildPackages,
  libGLU,
  libepoxy,
  libX11 ? null,
  libdrm,
  libgbm,
  vaapiSupport ? !stdenv.hostPlatform.isDarwin,
  libva,
  vulkanSupport ? stdenv.hostPlatform.isLinux,
  vulkan-headers,
  vulkan-loader,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "virglrenderer";
  version = "1.3.0";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/virgl/virglrenderer/-/archive/${version}/virglrenderer-${version}.tar.bz2";
    hash = "sha256-CIBA0TDqoEWKl4/nhn+/sfzx/f9SvzsnoAZYgovEGJ8=";
  };

  separateDebugInfo = true;

  buildInputs = [
    libepoxy
  ]
  ++ lib.optionals vaapiSupport [ libva ]
  ++ lib.optionals vulkanSupport [
    vulkan-headers
    vulkan-loader
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGLU
    libdrm
    libgbm
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    (python3.withPackages (ps: [
      ps.pyyaml
    ]))
  ];

  mesonEntries = {
    video = vaapiSupport;
    venus = vulkanSupport;
  };

  meta = {
    description = "Virtual 3D GPU library that allows a qemu guest to use the host GPU for accelerated 3D rendering";
    mainProgram = "virgl_test_server";
    homepage = "https://virgil3d.github.io/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
