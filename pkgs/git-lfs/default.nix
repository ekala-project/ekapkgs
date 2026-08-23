{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  asciidoctor,
  installShellFiles,
  git,
}:

buildGo126Module (finalAttrs: {
  pname = "git-lfs";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "git-lfs";
    repo = "git-lfs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N5ckTnyA3mueZre+rMhFZBiAFgEu4pmtzkiUidXnan8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-SUnZ9uN43CAw/iHC8cPBm3nYD03d3Pg2pYS2PwjDCnE=";

  nativeBuildInputs = [
    asciidoctor
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/git-lfs/git-lfs/v${lib.versions.major finalAttrs.version}/config.Vendor=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  preBuild = ''
    CC= GOOS= GOARCH= go generate ./commands
  '';

  postBuild = ''
    make man
  '';

  nativeCheckInputs = [ git ];

  preCheck = ''
    unset subPackages
  '';

  postInstall = ''
    installManPage man/man*/*
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd git-lfs \
      --bash <($out/bin/git-lfs completion bash) \
      --fish <($out/bin/git-lfs completion fish) \
      --zsh <($out/bin/git-lfs completion zsh)
  '';

  meta = {
    description = "Git extension for versioning large files";
    homepage = "https://git-lfs.github.com/";
    changelog = "https://github.com/git-lfs/git-lfs/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "git-lfs";
  };
})
