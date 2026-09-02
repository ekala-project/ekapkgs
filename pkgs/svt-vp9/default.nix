{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  yasm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "svt-vp9";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "OpenVisualCloud";
    repo = "SVT-VP9";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M7XpHCqTxGgk/UOlMR0jEXist6vGie6abRYLnVvC6sg=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    yasm
  ];

  meta = {
    description = "VP9-compliant encoder targeting performance levels applicable to both VOD and live video applications";
    changelog = "https://github.com/OpenVisualCloud/SVT-VP9/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/OpenVisualCloud/SVT-VP9";
    license = lib.licenses.bsd2Patent;
    mainProgram = "SvtVp9EncApp";
    platforms = [ "x86_64-linux" ];
  };
})
