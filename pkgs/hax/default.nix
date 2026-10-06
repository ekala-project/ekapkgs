{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  curl,
  jansson,
  versionCheckHook,
}:

stdenv.mkDerivation {
  pname = "hax";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "OleksandrChekhovskyi";
    repo = "hax";
    tag = "v0.5.0";
    hash = "sha256-d3gbxS+4q1UqtkGfcqF37yCKoQ4vprupgI2TN+3v4aM=";
  };

  nativeBuildInputs = [
    meson.configurePhaseHook
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    curl
    jansson
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Minimalist, terminal-native coding agent written in C";
    homepage = "https://usehax.dev";
    changelog = "https://github.com/OleksandrChekhovskyi/hax/releases/tag/v0.5.0";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "hax";
    platforms = lib.platforms.unix;
  };
}
