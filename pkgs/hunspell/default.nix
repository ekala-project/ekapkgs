{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  ncurses,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hunspell";
  version = "1.7.5";

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "hunspell";
    repo = "hunspell";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-K7r7t1ZIy1/LD1c24hpPEG8/+M9lmuwo2yVJ08I3YPE=";
  };

  postPatch = ''
    patchShebangs tests
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    ncurses
    readline
  ];

  autoreconfFlags = [ "-vfi" ];

  configureFlags = [
    "--with-ui"
    "--with-readline"
  ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Spell checker";
    homepage = "http://hunspell.github.io/";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
      mpl11
    ];
    mainProgram = "hunspell";
    platforms = lib.platforms.all;
  };
})
