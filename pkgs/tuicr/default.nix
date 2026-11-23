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
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "agavra";
    repo = "tuicr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NmQGLpZrwaI0jEz6Nj7y7E5bLfM6cXVS2ASM+p3Iusw=";
  };

  cargoHash = "sha256-bAHBnC0AmlETp262/Wx9INBv9QX7WUw6c3tXQ3K8x5s=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 ];

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
