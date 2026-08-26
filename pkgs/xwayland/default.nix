{
  dri-pkgconfig-stub,
  egl-wayland,
  bash,
  libepoxy,
  fetchurl,
  font-util,
  lib,
  libdecor,
  libgbm,
  libei,
  libGL,
  libGLU,
  libx11,
  libxau,
  libxaw,
  libxdmcp,
  libxext,
  libxfixes,
  libxfont_2 ? xorg.libXfont2,
  libxmu,
  libxpm,
  libxrender,
  libxres,
  libxt,
  libdrm,
  libtirpc,
  withLibunwind ? true,
  libunwind,
  libxcb,
  libxkbfile,
  libxshmfence,
  libxcvt,
  mesa-gl-headers,
  meson,
  ninja,
  openssl,
  pkg-config,
  pixman,
  stdenv,
  systemdMinimal,
  wayland,
  wayland-protocols,
  wayland-scanner,
  xkbcomp,
  xkeyboard_config ? xkeyboard-config,
  xkeyboard-config,
  xorg,
  xorgproto,
  xtrans,
  zlib,
  defaultFontPath ? "",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xwayland";
  version = "24.1.12";

  src = fetchurl {
    url = "mirror://xorg/individual/xserver/xwayland-${finalAttrs.version}.tar.xz";
    hash = "sha256-bfAsURuSwbmEhzTZ0bA6TCT4N1ujytpE6WhKIbX3jiE=";
  };

  postPatch = ''
    substituteInPlace os/utils.c \
      --replace-fail '/bin/sh' '${lib.getExe' bash "sh"}'
  '';

  depsBuildBuild = [
    pkg-config
  ];
  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    wayland-scanner
  ];
  buildInputs = [
    dri-pkgconfig-stub
    egl-wayland
    libdecor
    libgbm
    libepoxy
    libei
    font-util
    libGL
    libGLU
    libx11
    libxau
    libxaw
    libxdmcp
    libxext
    libxfixes
    libxfont_2
    libxmu
    libxpm
    libxrender
    libxres
    libxt
    libdrm
    libxcb
    libxkbfile
    libxshmfence
    libxcvt
    mesa-gl-headers
    openssl
    pixman
    wayland
    wayland-protocols
    xkbcomp
    xorgproto
    xtrans
    zlib
    libtirpc
    systemdMinimal
  ]
  ++ lib.optionals withLibunwind [
    libunwind
  ];

  mesonFlags = [
    (lib.mesonBool "xcsecurity" true)
    (lib.mesonOption "default_font_path" defaultFontPath)
    (lib.mesonOption "xkb_bin_dir" "${xkbcomp}/bin")
    (lib.mesonOption "xkb_dir" "${xkeyboard_config}/etc/X11/xkb")
    (lib.mesonOption "xkb_output_dir" "${placeholder "out"}/share/X11/xkb/compiled")
    (lib.mesonBool "libunwind" withLibunwind)
  ];

  meta = {
    description = "X server for interfacing X11 apps with the Wayland protocol";
    homepage = "https://gitlab.freedesktop.org/xorg/xserver";
    license = lib.licenses.mit;
    mainProgram = "Xwayland";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
