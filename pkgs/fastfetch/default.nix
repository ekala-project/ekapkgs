{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  dbus,
  dconf,
  ddcutil,
  glib,
  hwdata,
  imagemagick,
  libdrm,
  libelf ? null,
  libglvnd,
  libpulseaudio,
  libselinux,
  libsepol,
  libsysprof-capture,
  libva,
  libvdpau,
  libxau,
  libxcb,
  libxdmcp,
  libxext,
  libxrandr,
  ocl-icd,
  opencl-headers,
  pcre2,
  pkg-config,
  python3,
  rpm,
  sqlite,
  util-linux,
  vulkan-loader,
  wayland,
  xfconf,
  yyjson,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastfetch";
  version = "2.69.0";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "fastfetch-cli";
    repo = "fastfetch";
    tag = finalAttrs.version;
    hash = "sha256-osfQZEP6t3TdwlO+0agD8fU2z1UECJWLF+WPovwEk64=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    python3
  ];

  buildInputs = [
    imagemagick
    sqlite
    yyjson
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux (
    [
      dbus
      dconf
      ddcutil
      glib
      libdrm
      libglvnd
      libpulseaudio
      libselinux
      libsepol
      libsysprof-capture
      libva
      libvdpau
      libxau
      libxcb
      libxdmcp
      libxext
      libxrandr
      ocl-icd
      opencl-headers
      pcre2
      rpm
      util-linux
      vulkan-loader
      wayland
      xfconf
      zlib
    ]
    ++ lib.optionals (libelf != null) [ libelf ]
  );

  cmakeEntries = {
    ENABLE_CHAFA = false;
    ENABLE_DIRECTX_HEADERS = false;
    ENABLE_SYSTEM_YYJSON = true;
    ENABLE_IMAGEMAGICK6 = false;
    ENABLE_EMBEDDED_PCIIDS = true;
    ENABLE_EMBEDDED_AMDGPUIDS = true;
  };

  cmakeFlags = [
    (lib.cmakeOptionType "filepath" "CMAKE_INSTALL_SYSCONFDIR" "${placeholder "out"}/etc")
  ];

  postPatch = ''
    substituteInPlace completions/fastfetch.{bash,fish,zsh} --replace-fail python3 '${python3.interpreter}'
  '';

  preConfigure = lib.optionalString stdenv.hostPlatform.isLinux ''
    buildDir="''${cmakeBuildDir:-build}"
    mkdir -p "$buildDir"
    cp ${hwdata}/share/hwdata/pci.ids "$buildDir/pci.ids"
    cp ${libdrm}/share/libdrm/amdgpu.ids "$buildDir/amdgpu.ids"
  '';

  meta = {
    description = "Actively maintained, feature-rich and performance oriented, neofetch like system information tool";
    homepage = "https://github.com/fastfetch-cli/fastfetch";
    changelog = "https://github.com/fastfetch-cli/fastfetch/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "fastfetch";
  };
})
