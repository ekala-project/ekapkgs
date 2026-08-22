{
  lib,
  buildGo126Module,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  asciidoc ? null,
  databasePath ? "/etc/secureboot",
  pkg-config,
  pcsclite ? null,
}:

buildGo126Module (finalAttrs: {
  pname = "sbctl";
  version = "0.18";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "sbctl";
    tag = finalAttrs.version;
    hash = "sha256-Q8uQ74XvteMRcnUPu1PjLAPWt3jeI7aF4m3QMjiZJis=";
  };

  vendorHash = "sha256-PwLdWoC8tjdKoUAg2xvopggpgZ9WKaUslO3ZBtBah2k=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/foxboron/sbctl.DatabasePath=${databasePath}"
    "-X github.com/foxboron/sbctl.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ] ++ lib.optionals (asciidoc != null) [ asciidoc ];

  buildInputs = lib.optionals (pcsclite != null) [ pcsclite ];

  postBuild = lib.optionalString (asciidoc != null) ''
    make docs/sbctl.conf.5 docs/sbctl.8
  '';

  checkFlags = [
    "-skip"
    "github.com/google/go-tpm-tools/.*"
  ];

  postInstall =
    lib.optionalString (asciidoc != null) ''
      installManPage docs/sbctl.conf.5 docs/sbctl.8
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd sbctl \
        --bash <($out/bin/sbctl completion bash) \
        --fish <($out/bin/sbctl completion fish) \
        --zsh <($out/bin/sbctl completion zsh)
    '';

  meta = {
    description = "Secure Boot key manager";
    mainProgram = "sbctl";
    homepage = "https://github.com/Foxboron/sbctl";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
