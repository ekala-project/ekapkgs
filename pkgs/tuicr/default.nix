{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libgit2,
  testers,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuicr";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "agavra";
    repo = "tuicr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kObt0MLJZYASWM1vexZTPaIeFaU2XpT9sHUSdClRz2Y=";
  };

  cargoHash = "sha256-azgmxJP3iQO+WfJCWqfi19rCSb6D0a0luWcgEW+8Sbg=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libgit2 ];

  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Review AI-generated diffs like a GitHub pull request, right from your terminal";
    homepage = "https://github.com/agavra/tuicr";
    changelog = "https://github.com/agavra/tuicr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "tuicr";
    platforms = lib.platforms.unix;
  };
})
