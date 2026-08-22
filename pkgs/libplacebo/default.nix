{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  vulkan-headers,
  vulkan-loader,
  shaderc,
  lcms2,
  libGL,
  libx11,
  libunwind,
  libdovi,
  xxhash,
  fast-float,
  vulkanSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libplacebo";
  version = "7.360.1";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = "libplacebo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h8uMWRe4SysbKNLWdGYxAwj2k7yh4sO62/Ca30mRT3g=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3Packages.jinja2
    python3Packages.glad2
  ];

  buildInputs = [
    shaderc
    lcms2
    libGL
    libx11
    libunwind
    libdovi
    xxhash
    vulkan-headers
  ]
  ++ lib.optionals vulkanSupport [
    vulkan-loader
  ]
  ++ lib.optionals (!stdenv.cc.isGNU) [
    fast-float
  ];

  mesonFlags = [
    (lib.mesonBool "demos" false)
    (lib.mesonEnable "d3d11" false)
    (lib.mesonEnable "glslang" false)
    (lib.mesonEnable "vk-proc-addr" vulkanSupport)
    (lib.mesonOption "vulkan-registry" "${vulkan-headers}/share/vulkan/registry/vk.xml")
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace 'python_env.append' '#'
  '';

  meta = {
    description = "Reusable library for GPU-accelerated video/image rendering primitives";
    longDescription = ''
      Reusable library for GPU-accelerated image/view processing primitives and
      shaders, as well a batteries-included, extensible, high-quality rendering
      pipeline (similar to mpv's vo_gpu). Supports Vulkan, OpenGL and Metal (via
      MoltenVK).
    '';
    homepage = "https://code.videolan.org/videolan/libplacebo";
    changelog = "https://code.videolan.org/videolan/libplacebo/-/tags/v${finalAttrs.version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
