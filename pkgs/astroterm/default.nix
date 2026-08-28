{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  xxd,
  meson,
  ninja,
  ncurses,
  argtable,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "astroterm";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "da-luce";
    repo = "astroterm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u0UKYoZCDClRmG12czmm0rmOcy3nruarSyjdh8Lu2dw=";
  };

  bsc5File = fetchurl {
    url = "https://web.archive.org/web/20231007085824/http://tdc-www.harvard.edu/catalogs/BSC5";
    hash = "sha256-5HHQLq9O7LYcEvh5octkMrqde2ipqMVlSh60KgyMw0A=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    xxd
  ];
  buildInputs = [
    argtable
    ncurses
  ];

  postPatch = ''
    mkdir -p data
    ln -s ${finalAttrs.bsc5File} data/bsc5
  '';

  doCheck = true;

  meta = {
    description = "Celestial viewer for the terminal, written in C";
    homepage = "https://github.com/da-luce/astroterm/";
    license = lib.licenses.mit;
    mainProgram = "astroterm";
    platforms = lib.platforms.unix;
  };
})
