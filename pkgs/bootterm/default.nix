{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bootterm";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "wtarreau";
    repo = "bootterm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AYpO2Xcd51B2qVUWoyI190BV0pIdA3HfuQJPzJ4yT/U=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Simple, reliable and powerful terminal to ease connection to serial ports";
    homepage = "https://github.com/wtarreau/bootterm";
    license = lib.licenses.mit;
    mainProgram = "bt";
    platforms = lib.platforms.unix;
  };
})
