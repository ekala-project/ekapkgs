{
  stdenv,
  lib,
  fetchFromGitLab,
  ncurses,
  pkg-config,
  scdoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cbonsai";
  version = "1.4.2";

  src = fetchFromGitLab {
    owner = "jallbrit";
    repo = "cbonsai";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TZb/5DBdWcl54GoZXxz2xYy9dXq5lmJQsOA3C26tjEU=";
  };

  nativeBuildInputs = [
    pkg-config
    scdoc
  ];
  buildInputs = [ ncurses ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Grow bonsai trees in your terminal";
    mainProgram = "cbonsai";
    homepage = "https://gitlab.com/jallbrit/cbonsai";
    license = with lib.licenses; [ gpl3Only ];
    platforms = lib.platforms.unix;
  };
})
