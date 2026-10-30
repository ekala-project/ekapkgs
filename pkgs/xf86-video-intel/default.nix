{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  dri-pkgconfig-stub,
  libdrm,
  libpciaccess,
  libpng,
  libx11,
  libxcb,
  libxcb-util,
  libxcursor,
  libxdamage,
  libxfixes,
  libxinerama,
  libxrandr,
  libxrender,
  libxscrnsaver,
  libxshmfence,
  libxtst,
  libxv,
  libxvmc,
  libxxf86vm,
  pixman,
  valgrind,
  xorgproto,
  xorg-server,
}:

stdenv.mkDerivation {
  pname = "xf86-video-intel";
  version = "unstable-2025-03-21";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-intel";
    rev = "4a64400ec6a7d8c0aba0e6a39b16a5e86d0af843";
    hash = "sha256-bwyNVHSTnbyxU6059nITk4TNBEly39xPB67gGOPkmYU=";
  };

  patches = [
    # The i965 driver was removed in Mesa 22. Use crocus/iris instead.
    ./use_crocus_and_iris.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    dri-pkgconfig-stub
    libdrm
    libpciaccess
    libpng
    libx11
    libxcb
    libxcb-util
    libxcursor
    libxdamage
    libxfixes
    libxinerama
    libxrandr
    libxrender
    libxscrnsaver
    libxshmfence
    libxtst
    libxv
    libxvmc
    libxxf86vm
    pixman
    valgrind
    xorgproto
    xorg-server
  ];

  mesonFlags = [
    "-Ddefault-dri=3"
    "-Dtools=true"
  ];

  meta = {
    description = "Open-source Xorg graphics driver for Intel graphics";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-intel";
    license = with lib.licenses; [
      mit
      hpndSellVariant
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
