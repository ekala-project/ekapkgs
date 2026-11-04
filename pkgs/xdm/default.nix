{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  util-macros,
  autoreconfHook,
  wrapWithXFileSearchPathHook,
  libx11,
  libxau,
  libxaw,
  libxcrypt,
  libxdmcp,
  libxext,
  libxft,
  libxinerama,
  libxmu,
  libxpm,
  libxrender,
  libxt,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xdm";
  version = "1.1.17";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xorg";
    repo = "app/xdm";
    tag = "xdm-${finalAttrs.version}";
    hash = "sha256-PhMctvL+Vp9uNmTtowMHzkoekieVCgNZCfUZ1XpjpyY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    util-macros
    autoreconfHook
    wrapWithXFileSearchPathHook
  ];

  buildInputs = [
    libx11
    libxau
    libxaw
    libxcrypt
    libxdmcp
    libxext
    libxft
    libxinerama
    libxmu
    libxpm
    libxrender
    libxt
  ];

  configureFlags = [
    "ac_cv_path_RAWCPP=${stdenv.cc.targetPrefix}cpp"
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "ac_cv_file__dev_urandom=true"
    "ac_cv_file__dev_random=true"
  ];

  installFlags = [ "appdefaultdir=$(out)/share/X11/app-defaults" ];

  meta = {
    description = "X Display Manager with support for XDMCP, host chooser";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xdm";
    license = with lib.licenses; [
      mit
      x11
      bsd2
    ];
    mainProgram = "xdm";
    platforms = lib.platforms.unix;
  };
})
