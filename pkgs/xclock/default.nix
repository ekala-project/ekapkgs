{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  wrapWithXFileSearchPathHook ? null,
  libx11,
  libxaw,
  libxft,
  libxkbfile,
  libxmu,
  libxrender,
  libxt,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xclock";
  version = "1.2.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xclock";
    tag = "xclock-${finalAttrs.version}";
    hash = "sha256-e8P1tMLwFMThc0WIJTm5E0jAjJnCF8cdrHtp7tKN8IQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ]
  ++ lib.optional (wrapWithXFileSearchPathHook != null) wrapWithXFileSearchPathHook;

  buildInputs = [
    libx11
    libxaw
    libxft
    libxkbfile
    libxmu
    libxrender
    libxt
    xorgproto
  ];

  mesonFlags = [
    (lib.mesonOption "appdefaultdir" "${placeholder "out"}/share/X11/app-defaults")
  ];

  meta = {
    description = "analog / digital clock for X";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xclock";
    license = with lib.licenses; [
      mitOpenGroup
      hpnd
      mit
    ];
    mainProgram = "xclock";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
