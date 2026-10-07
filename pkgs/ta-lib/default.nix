{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ta-lib";
  version = "0.8.1";
  src = fetchFromGitHub {
    owner = "TA-Lib";
    repo = "ta-lib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c8OSwb2H4ior015cXu2+SixSlFzLqeb9K19VNk3XEbc=";
  };
  nativeBuildInputs = [ autoreconfHook ];
  meta = {
    description = "Add technical analysis to your own financial market trading applications";
    mainProgram = "ta-lib-config";
    homepage = "https://ta-lib.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
