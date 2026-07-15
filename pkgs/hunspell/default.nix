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
  version = "1.7.2";

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
    sha256 = "sha256-x2FXxnVIqsf5/UEQcvchAndXBv/3mW8Z55djQAFgNA8=";
  };

  patches = [ ./0001-Make-hunspell-look-in-XDG_DATA_DIRS-for-dictionaries.patch ];

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
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
