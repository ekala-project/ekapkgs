{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "multitime";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = "multitime";
    rev = "multitime-${finalAttrs.version}";
    sha256 = "sha256-oLtBUJbu+tVhzsUv+toz2oLeXCVLYKHQXUNsqpCZBGc=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Time command execution over multiple executions";
    license = lib.licenses.mit;
    homepage = "https://tratt.net/laurie/src/multitime/";
    platforms = lib.platforms.unix;
    mainProgram = "multitime";
  };
})
