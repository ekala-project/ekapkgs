{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wpprobe";
  version = "0.12.11";

  src = fetchFromGitHub {
    owner = "Chocapikk";
    repo = "wpprobe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DEDbLnQRAYex6OAHoXRHxE6SQ5C/uTznk7klTosiauk=";
  };

  vendorHash = "sha256-0l7n6u2iODxoVR1fIMyUBaQj7cYk0Q5VnXUePaqOHXc=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/Chocapikk/wpprobe/internal/version.Version=v${finalAttrs.version}"
  ];

  doCheck = false;

  meta = {
    description = "WordPress plugin enumeration tool";
    homepage = "https://github.com/Chocapikk/wpprobe";
    changelog = "https://github.com/Chocapikk/wpprobe/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "wpprobe";
  };
})
