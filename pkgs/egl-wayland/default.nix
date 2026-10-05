{
  lib,
  stdenv,
  fetchFromGitHub,
  eglexternalplatform,
  pkg-config,
  meson,
  ninja,
  wayland-scanner,
  libGL,
  xorg,
  libdrm,
  wayland,
  wayland-protocols,
}:

stdenv.mkDerivation rec {
  pname = "egl-wayland";
  version = "1.1.23";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Nvidia";
    repo = "egl-wayland";
    rev = version;
    hash = "sha256-M+s2R0vSDCEN9lMma6RiJTqzUgClnszwS4aKBJeBvFQ=";
  };

  postPatch = ''
    # Declares an includedir but doesn't install any headers
    # CMake's `pkg_check_modules(NAME wayland-eglstream IMPORTED_TARGET)` considers this an error
    sed -i -e '/includedir/d' wayland-eglstream.pc.in
  '';

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libGL
    xorg.libX11
    libdrm
    wayland
    wayland-protocols
  ];

  propagatedBuildInputs = [
    eglexternalplatform
  ];

  meta = {
    description = "EGLStream-based Wayland external platform";
    homepage = "https://github.com/NVIDIA/egl-wayland/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
