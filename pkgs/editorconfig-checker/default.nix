{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
}:

buildGo126Module (finalAttrs: {
  pname = "editorconfig-checker";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "editorconfig-checker";
    repo = "editorconfig-checker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t0EliFWYYxKfPbfLKP4p3wJvmIfXF6CPpWIgUuD3pXY=";
  };

  vendorHash = "sha256-5x7c8v+uMmqvyQnN47XgD8FFMoEq5/MPFO2WEj0WevU=";

  # Tests run on source and don't expect vendor dir.
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-X main.version=${finalAttrs.version}" ];

  postInstall = ''
    installManPage docs/editorconfig-checker.1
  '';

  meta = {
    changelog = "https://github.com/editorconfig-checker/editorconfig-checker/releases/tag/${finalAttrs.src.tag}";
    description = "Tool to verify that your files are in harmony with your .editorconfig";
    mainProgram = "editorconfig-checker";
    homepage = "https://editorconfig-checker.github.io/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
