{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  pkgsCross,
}:

buildGoModule (finalAttrs: {
  pname = "moor";
  version = "2.15.2";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "moor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3HG3qiUGbrv/2HGvZ1gsLMs59fQZboXxcT/YCUfzT4Y=";
  };

  vendorHash = "sha256-PGJ6aSRYgLztkQxHQvXn5ISBK5DIa76lJSOsMTGJNpw=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.versionString=v${finalAttrs.version}"
  ];
  postInstall = ''
    installManPage ./moor.1
  '';

  passthru = {
    tests.cross-aarch64 = pkgsCross.aarch64-multiplatform.moor;
  };

  meta = {
    description = "Nice-to-use pager for humans";
    homepage = "https://github.com/walles/moor";
    changelog = "https://github.com/walles/moor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2WithViews;
    mainProgram = "moor";
    maintainers = [ ];
  };
})
