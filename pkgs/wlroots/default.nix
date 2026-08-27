{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  libGL,
  wayland,
  wayland-protocols,
  libinput,
  libxkbcommon,
  pixman,
  libcap,
  libgbm,
  libxcb-wm,
  libxcb-render-util,
  libxcb-image,
  libxcb-errors ? null,
  libx11,
  hwdata,
  seatd,
  vulkan-loader,
  glslang,
  libliftoff,
  libdisplay-info,
  lcms2,

  enableXWayland ? false,
  xwayland ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wlroots";
  version = "0.20.2";

  inherit enableXWayland;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "wlroots";
    repo = "wlroots";
    rev = finalAttrs.version;
    hash = "sha256-VdYymvzYp6/R255AK20j4xTd+JbCZgNiRfgeRJD+UZY=";
  };

  outputs = [
    "out"
    "examples"
  ];

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    glslang
    hwdata
  ];

  propagatedBuildInputs = [
    libinput
  ];

  buildInputs = [
    libliftoff
    libdisplay-info
    libGL
    libxkbcommon
    libgbm
    pixman
    seatd
    vulkan-loader
    wayland
    wayland-protocols
    libx11
    libxcb-image
    libxcb-render-util
    libxcb-wm
    lcms2
  ]
  ++ lib.optional (libxcb-errors != null) libxcb-errors
  ++ lib.optional stdenv.hostPlatform.isLinux libcap
  ++ lib.optional finalAttrs.enableXWayland xwayland;

  mesonFlags = [
    (lib.mesonEnable "xwayland" finalAttrs.enableXWayland)
  ];

  postFixup = ''
    mkdir -p $examples/bin
    cd ./examples
    for binary in $(find . -executable -type f -printf '%P\n' | grep -vE '\.so'); do
      cp "$binary" "$examples/bin/wlroots-$binary"
    done
  '';

  meta = {
    description = "Modular Wayland compositor library";
    longDescription = ''
      Pluggable, composable, unopinionated modules for building a Wayland
      compositor; or about 50,000 lines of code you were going to write anyway.
    '';
    inherit (finalAttrs.src.meta) homepage;
    changelog = "https://gitlab.freedesktop.org/wlroots/wlroots/-/tags/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
