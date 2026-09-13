{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libtoxcore,
  filter-audio,
  dbus,
  libvpx,
  libx11,
  openal,
  freetype,
  libv4l,
  libxrender,
  fontconfig,
  libxext,
  libxft,
  libsodium,
  libopus,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "utox";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "uTox";
    repo = "uTox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DxnolxUTn+CL6TbZHKLHOUMTHhtTSWufzzOTRpKjOwc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    libtoxcore
    dbus
    libvpx
    libx11
    openal
    freetype
    libv4l
    libxrender
    fontconfig
    libxext
    libxft
    filter-audio
    libsodium
    libopus
  ];

  cmakeFlags = [
    "-DENABLE_AUTOUPDATE=OFF"
    "-DENABLE_TESTS=OFF"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.2)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "Lightweight Tox client";
    mainProgram = "utox";
    homepage = "https://github.com/uTox/uTox";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
})
