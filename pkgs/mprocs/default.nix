{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mprocs";
  version = "0.10.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pvolok";
    repo = "dekit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kj+iWiRyRavCHgpZLPUPWqeItlD079OTO0lkaS3qpsc=";
  };

  cargoHash = "sha256-g7RJa3wOv4tr7IW3SWHie78t3qTqHV3HMHobgQW2jS8=";

  meta = {
    description = "TUI tool to run multiple commands in parallel and show the output of each command separately";
    homepage = "https://github.com/pvolok/dekit";
    changelog = "https://github.com/pvolok/dekit/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "mprocs";
  };
})
