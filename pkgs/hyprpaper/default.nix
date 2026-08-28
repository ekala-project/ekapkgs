{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  cmake,
  hyprwayland-scanner,
  hyprwire,
  pkg-config,
  wayland-scanner,
  aquamarine,
  cairo,
  expat,
  file,
  fribidi,
  hyprgraphics,
  hyprlang,
  hyprutils,
  hyprtoolkit,
  libGL,
  libdatrie,
  libdrm,
  libjpeg,
  libjxl,
  libselinux,
  libsepol,
  libthai,
  libwebp,
  libxdmcp,
  pango,
  pcre2,
  wayland,
  wayland-protocols,
  util-linux,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpaper";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpaper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/4eWbt5XtOHzw3C9U0XPtoy8io03GxrEBd9znWMacbY=";
  };

  prePatch = ''
    substituteInPlace src/main.cpp \
      --replace-fail GIT_COMMIT_HASH '"${finalAttrs.src.tag}"'
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    hyprwayland-scanner
    hyprwire
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    aquamarine
    cairo
    expat
    file
    fribidi
    hyprgraphics
    hyprlang
    hyprutils
    hyprtoolkit
    libGL
    libdatrie
    libdrm
    libjpeg
    libjxl
    libselinux
    libsepol
    libthai
    libwebp
    libxdmcp
    pango
    pcre2
    wayland
    wayland-protocols
    util-linux
  ];

  meta = {
    homepage = "https://github.com/hyprwm/hyprpaper";
    description = "Blazing fast wayland wallpaper utility";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    mainProgram = "hyprpaper";
  };
})
