{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "brush";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "reubeno";
    repo = "brush";
    tag = "brush-shell-v${finalAttrs.version}";
    hash = "sha256-zG6ho/QECzLC/evOUdo9mYXoh4xA2PF+BQvnCsLZiNg=";
  };

  cargoHash = "sha256-NSvlLiLp0kdnWNUSIateGkscL5as+b00d54CP3sEakI=";

  # Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  doCheck = false;

  meta = {
    description = "Bash/POSIX-compatible shell implemented in Rust";
    homepage = "https://github.com/reubeno/brush";
    changelog = "https://github.com/reubeno/brush/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "brush";
  };
})
