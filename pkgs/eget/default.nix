{
  lib,
  fetchFromGitHub,
  buildGo126Module,
  pandoc ? null,
  installShellFiles,
}:

buildGo126Module (finalAttrs: {
  pname = "eget";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = "eget";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-jhVUYyp6t5LleVotQQme07IJVdVnIOVFFtKEmzt8e2k=";
  };

  vendorHash = "sha256-A3lZtV0pXh4KxINl413xGbw2Pz7OzvIQiFSRubH428c=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals (pandoc != null) [ pandoc ];

  postInstall = ''
    rm $out/bin/{test,tools}
  ''
  + lib.optionalString (pandoc != null) ''
    pandoc man/eget.md -s -t man -o eget.1
    installManPage eget.1
  '';

  meta = {
    description = "Easily install prebuilt binaries from GitHub";
    homepage = "https://github.com/zyedidia/eget";
    license = lib.licenses.mit;
  };
})
