{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  pkg-config,
  ninja,
  libx11,
  libxcb,
  libxext,
  libxi,
  libxtst,
  libxcomposite,
  libxinerama,
  libxpresent,
  libxrandr,
  libxrender,
  libxxf86dga,
  libxxf86vm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdpyinfo";
  version = "1.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xorg";
    repo = "app/xdpyinfo";
    tag = "xdpyinfo-${finalAttrs.version}";
    hash = "sha256-zN2ViUJhrndqyLFCzcUi2DRg2K2q9eJXzHlUsMNmhNg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [
    libx11
    libxcb
    libxext
    libxi
    libxtst
    libxcomposite
    libxinerama
    libxpresent
    libxrandr
    libxrender
    libxxf86dga
    libxxf86vm
  ];

  meta = {
    description = "Display information utility for X";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xdpyinfo";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "xdpyinfo";
    platforms = lib.platforms.unix;
  };
})
