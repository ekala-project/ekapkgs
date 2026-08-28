{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "lazydocker";
  version = "0.25.2";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazydocker";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-MHSZ0O8LPx1SOhrUK0sh73jDvDvu31Qsw+yjsTMQN/Y=";
  };

  vendorHash = null;

  postPatch = ''
    rm -f pkg/config/app_config_test.go
  '';

  excludedPackages = [
    "scripts"
    "test/printrandom"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Simple terminal UI for both docker and docker-compose";
    homepage = "https://github.com/jesseduffield/lazydocker";
    license = lib.licenses.mit;
    mainProgram = "lazydocker";
  };
})
