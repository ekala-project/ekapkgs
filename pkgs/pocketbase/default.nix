{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pocketbase";
  version = "0.39.9";

  src = fetchFromGitHub {
    owner = "pocketbase";
    repo = "pocketbase";
    rev = "v${finalAttrs.version}";
    hash = "sha256-owOE7rEP2junyzLsECv+Qf4z6mq2dJu5R0XR0oCIMo8=";
  };

  vendorHash = "sha256-jA/MazIBK2iJUI7fd/oRsXyC4HSnfh7iyB5xHLnZRYs=";

  # This is the released subpackage from upstream repo
  subPackages = [ "examples/base" ];

  env.CGO_ENABLED = 0;

  # Upstream build instructions
  ldflags = [
    "-s"
    "-w"
    "-X github.com/pocketbase/pocketbase.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/base $out/bin/pocketbase
  '';
  meta = {
    description = "Open Source realtime backend in 1 file";
    homepage = "https://github.com/pocketbase/pocketbase";
    license = lib.licenses.mit;
    mainProgram = "pocketbase";
  };
})
