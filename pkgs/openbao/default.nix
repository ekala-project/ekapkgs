{
  lib,
  fetchFromGitHub,
  buildGo126Module,
  installShellFiles,
  stdenvNoCC,
  withHsm ? stdenvNoCC.hostPlatform.isLinux,
}:

buildGo126Module (finalAttrs: {
  pname = "openbao";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2wl06I6/yF/V5P9MFCCzpEiX4G+YTtXWRjvh+wDyB1U=";
  };

  vendorHash = "sha256-2MMWs30e7GB0pcPmmDvw6RTBzKYXNwothAuQMZAFHoE=";

  proxyVendor = true;

  subPackages = [ "." ];

  tags = lib.optional withHsm "hsm";

  ldflags = [
    "-s"
    "-X github.com/openbao/openbao/version.GitCommit=${finalAttrs.src.rev}"
    "-X github.com/openbao/openbao/version.fullVersion=${finalAttrs.version}"
    "-X github.com/openbao/openbao/version.buildDate=1970-01-01T00:00:00Z"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    mv $out/bin/openbao $out/bin/bao

    # https://github.com/posener/complete/blob/9a4745ac49b29530e07dc2581745a218b646b7a3/cmd/install/bash.go#L8
    installShellCompletion --bash --name bao <(echo complete -C "$out/bin/bao" bao)
  '';

  meta = {
    homepage = "https://www.openbao.org/";
    description = "Open source, community-driven fork of Vault managed by the Linux Foundation";
    changelog = "https://github.com/openbao/openbao/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    mainProgram = "bao";
    maintainers = [ ];
  };
})
