{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  fontconfig,
  freetype,
  libx11,
  libxft,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "st";
  version = "0.9.2";

  src = fetchurl {
    url = "https://dl.suckless.org/st/st-${finalAttrs.version}.tar.gz";
    hash = "sha256-ayFdT0crIdYjLzDyIRF6d34kvP7miVXd77dCZGf5SUs=";
  };

  outputs = [
    "out"
    "terminfo"
  ];

  strictDeps = true;

  makeFlags = [
    "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
  ];

  nativeBuildInputs = [
    pkg-config
    ncurses
    fontconfig
    freetype
  ];

  buildInputs = [
    libx11
    libxft
  ];

  preInstall = ''
    export TERMINFO=$terminfo/share/terminfo
    mkdir -p $TERMINFO $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://st.suckless.org/";
    description = "Simple Terminal for X from Suckless.org Community";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "st";
  };
})
