{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "curseofwar";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "a-nikolaev";
    repo = "curseofwar";
    rev = "v${finalAttrs.version}";
    sha256 = "1wd71wdnj9izg5d95m81yx3684g4zdi7fsy0j5wwnbd9j34ilz1i";
  };

  buildInputs = [
    ncurses
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  meta = {
    description = "Fast-paced action strategy game";
    homepage = "https://a-nikolaev.github.io/curseofwar/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    mainProgram = "curseofwar";
  };
})
