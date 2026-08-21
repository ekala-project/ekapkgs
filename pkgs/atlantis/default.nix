{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "atlantis";
  version = "0.46.0";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4twWPp+ZgK6YmNL5RJmLKhtxe33T1GDCu1qejUbqXkA=";
  };

  ldflags = [
    "-X=main.version=${finalAttrs.version}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  vendorHash = "sha256-/PnEQvaqADxwFvrHWOPFopQwdyUXBa6cf/H7a/RaHcg=";

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/runatlantis/atlantis";
    description = "Terraform Pull Request Automation";
    mainProgram = "atlantis";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
