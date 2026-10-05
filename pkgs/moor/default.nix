{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  pkgsCross,
}:

buildGoModule (finalAttrs: {
  pname = "moor";
  version = "2.19.2";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "moor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fwXWMreyB3Hr+6BMDZ4M6IPOl6FNcvVgU/c3Guf3+YU=";
  };

  vendorHash = "sha256-ygMUnuIqr+rIw5+nJSUFomr5VokhqVQfWs9nQHeoQ0U=";

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
  };
})
