{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  pandoc ? null,
  go,
}:

buildGo126Module (finalAttrs: {
  pname = "checkmake";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "checkmake";
    repo = "checkmake";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5GIqmcIj1jU4lOqrFxuI8lDNYYpsRnUSft6RYGRbiAE=";
  };

  vendorHash = "sha256-Iv3MFhHnwDLIuUH7G6NYyQUSAaivBYqYDWephHnBIho=";

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals (pandoc != null) [ pandoc ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.buildTime=1970-01-01T00:00:00Z"
    "-X=main.builder=nixpkgs"
    "-X=main.goversion=go${go.version}"
  ];

  postPatch = ''
    substituteInPlace man/man1/checkmake.1.md \
      --replace REPLACE_DATE 1970-01-01T00:00:00Z
  '';

  postBuild = lib.optionalString (pandoc != null) ''
    pandoc man/man1/checkmake.1.md -st man -o man/man1/checkmake.1
  '';

  postInstall = lib.optionalString (pandoc != null) ''
    installManPage man/man1/checkmake.1
  '';

  meta = {
    description = "Linter and analyzer for Makefiles";
    mainProgram = "checkmake";
    homepage = "https://github.com/checkmake/checkmake";
    changelog = "https://github.com/checkmake/checkmake/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
