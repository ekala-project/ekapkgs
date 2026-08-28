{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smenu";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "p-gen";
    repo = "smenu";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-nTQe6sCMHGRW7Djpv33xY8nL4a7ZyC9YM7PGOvmpuSM=";
  };

  buildInputs = [ ncurses ];

  meta = {
    description = "Terminal selection utility";
    homepage = "https://github.com/p-gen/smenu";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    mainProgram = "smenu";
  };
})
