{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  mockgen,
}:
buildGo126Module (finalAttrs: {
  pname = "terragrunt";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "terragrunt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JovTD88P/9IUX1y1AG/NhkIRRPCa0eAwJSx5qfg+4Ck=";
  };

  nativeBuildInputs = [
    mockgen
  ];

  proxyVendor = true;

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-eqoT9On/nGwJIbWug4RQVmibbsqbTRa5MzOoFXgGmxc=";

  excludedPackages = [ "test/flake" ];

  doCheck = false;

  ldflags = [
    "-s"
    "-X github.com/gruntwork-io/go-commons/version.Version=v${finalAttrs.version}"
    "-extldflags '-static'"
  ];

  nativeInstallCheckInputs = [
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    homepage = "https://terragrunt.gruntwork.io";
    changelog = "https://github.com/gruntwork-io/terragrunt/releases/tag/v${finalAttrs.version}";
    description = "Thin wrapper for Terraform that supports locking for Terraform state and enforces best practices";
    mainProgram = "terragrunt";
    license = lib.licenses.mit;
  };
})
