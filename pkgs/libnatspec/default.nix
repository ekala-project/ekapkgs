{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  popt,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnatspec";
  version = "325624.100";

  src = fetchFromGitHub {
    owner = "Etersoft";
    repo = "libnatspec";
    tag = "gb-sisyphus-task325624.100";
    hash = "sha256-kwQ+sZU4ElJwPk0WiRtQIbqkLlxxuBV0YRIA0ibZvM8=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ popt ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-liconv";
  };

  propagatedBuildInputs = [ libiconv ];

  meta = {
    homepage = "https://github.com/Etersoft/libnatspec";
    description = "Library intended to smooth national specificities in using of programs";
    mainProgram = "natspec";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl21;
  };
})
