{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "act";
  version = "0.2.89";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = "act";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K3+JJHadA/+aayI5XtGBLgFRbCuu6Uilm45kumnlZUw=";
  };

  vendorHash = "sha256-Gp4Bxq0n1gmqHwrggSonMsFbWMVeCIgeVKY1U1Oe6lU=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Run your GitHub Actions locally";
    mainProgram = "act";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
  };
})
