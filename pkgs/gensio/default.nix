{
  autoreconfHook,
  fetchFromGitHub,
  lib,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gensio";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = "gensio";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-BCtKGJVmyEZ6zN1yPFtQx5B8zoamjdECAJRGElsm4OA=";
  };

  configureFlags = [
    "--with-python=no"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = {
    description = "General Stream I/O";
    homepage = "https://sourceforge.net/projects/ser2net/";
    license = lib.licenses.gpl2;
    mainProgram = "gensiot";
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
