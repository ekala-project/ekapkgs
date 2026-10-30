{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libquvi-scripts";
  version = "0.9.20131130";

  src = fetchFromGitHub {
    owner = "guendto";
    repo = "libquvi-scripts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t8xSt7hsoN8ZdZknbsPW4z/7e+qOKzyTBlUHMmgMjnU=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Scripts for libquvi, a library for parsing video download links";
    homepage = "https://github.com/guendto/libquvi-scripts";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
