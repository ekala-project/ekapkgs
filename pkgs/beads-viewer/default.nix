{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "beads-viewer";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "Dicklesworthstone";
    repo = "beads_viewer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-19JqPj/Gae7VR7iM4B8KeHdW2HBhZVptrnNhHrtYrGQ=";
  };

  vendorHash = null;

  # Drop the toolchain directive that pins a newer Go than the package set.
  postPatch = ''
    sed -i '/^toolchain /d' go.mod
  '';

  subPackages = [ "cmd/bv" ];

  ldflags = [
    "-s"
    "-w"
    # Upstream resolves the exported Version in init() from the unexported
    # `version` variable, so inject there.
    "-X github.com/Dicklesworthstone/beads_viewer/pkg/version.version=v${finalAttrs.version}"
  ];

  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Graph-aware TUI for the Beads issue tracker";
    homepage = "https://github.com/Dicklesworthstone/beads_viewer";
    changelog = "https://github.com/Dicklesworthstone/beads_viewer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "bv";
    platforms = lib.platforms.unix;
  };
})
