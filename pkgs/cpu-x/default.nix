{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtk3,
  ncurses,
  libcpuid,
  pciutils,
  procps,
  nasm,
  opencl-headers,
  ocl-icd,
  vulkan-headers,
  vulkan-loader,
  glfw3,
  libxdmcp,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  libxkbcommon,
  libepoxy,
  dbus,
  at-spi2-core,
  libxtst,
  gtkmm3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpu-x";
  version = "5.4.1";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "TheTumultuousUnicornOfDarkness";
    repo = "CPU-X";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FB3AaFdmDOh58/ym7iKPZo/T/sx7uU4SwUIM3EOrwBs=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    gtk3.wrapGAppsHook
    nasm
  ];

  buildInputs = [
    gtk3
    gtkmm3
    ncurses
    libcpuid
    pciutils
    procps
    vulkan-headers
    vulkan-loader
    glfw3
    opencl-headers
    ocl-icd
    libxdmcp
    util-linux
    libselinux
    libsepol
    libthai
    libdatrie
    libxkbcommon
    libepoxy
    dbus
    at-spi2-core
    libxtst
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}
      --prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib
    )
  '';

  meta = {
    description = "Free software that gathers information on CPU, motherboard and more";
    mainProgram = "cpu-x";
    homepage = "https://thetumultuousunicornofdarkness.github.io/CPU-X";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
  };
})
