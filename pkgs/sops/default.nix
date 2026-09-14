{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "sops";
  version = "3.13.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "getsops";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-TLThUgoJKcqqzQBIPzXLK+4VznMEf1wEkDUbz2pijiE=";
  };

  vendorHash = "sha256-LHMmSO6IDZA0hbattv3jM+9xLd57VrulVxOn+uYG4n0=";

  subPackages = [ "cmd/sops" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/getsops/sops/v3/version.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postInstall = ''
    installShellCompletion --cmd sops --bash ${./bash_autocomplete}
    installShellCompletion --cmd sops --zsh ${./zsh_autocomplete}
  '';

  meta = {
    homepage = "https://getsops.io/";
    description = "Simple and flexible tool for managing secrets";
    changelog = "https://github.com/getsops/sops/blob/v${finalAttrs.version}/CHANGELOG.md";
    mainProgram = "sops";
    license = lib.licenses.mpl20;
  };
})
