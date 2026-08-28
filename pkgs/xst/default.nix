{
  lib,
  stdenv,
  fetchFromGitHub,
  fontconfig,
  libx11,
  libxext,
  libxft,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xst";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "gnotclub";
    repo = "xst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2pXR9U2tTBd0lyeQ3BjnXW+Ne9aUQg/+rnpmYPPG06A=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    fontconfig
    libx11
    libxext
    libxft
    ncurses
  ];

  installFlags = [
    "TERMINFO=$(out)/share/terminfo"
    "PREFIX=$(out)"
  ];
  meta = {
    homepage = "https://github.com/gnotclub/xst";
    description = "Simple terminal fork that can load config from Xresources";
    mainProgram = "xst";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
