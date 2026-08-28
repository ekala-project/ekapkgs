{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "wpprobe";
  version = "0.12.7";

  src = fetchFromGitHub {
    owner = "Chocapikk";
    repo = "wpprobe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OPVu1Kxq/szv01VUKnkWfsxwy3Brz73pz4otkOTjwgk=";
  };

  vendorHash = "sha256-pAKFrdja+rH0kiJH6hToZwLjE8lLBHFAUCjnCLbgxVo=";

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
