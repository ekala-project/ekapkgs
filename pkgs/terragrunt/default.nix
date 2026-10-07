{
  lib,
  buildGoModule,
  fetchFromGitHub,
  mockgen,
}:
buildGoModule (finalAttrs: {
  pname = "terragrunt";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "terragrunt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a0RrIOBLVaR+2+53Yw+olWj92eX6RHEhvT1GwXg56sw=";
  };

  nativeBuildInputs = [
    mockgen
  ];

  proxyVendor = true;

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-JYzCoOo4GVGj4TJYsMpPksFn6KBNd9n8klJ5bueSJzk=";

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
