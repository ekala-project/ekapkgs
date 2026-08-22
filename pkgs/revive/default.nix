{
  buildGo126Module,
  fetchFromGitHub,
  lib,
}:

buildGo126Module (finalAttrs: {
  pname = "revive";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "mgechev";
    repo = "revive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FA3IP8TNY911CasYI+m+qpNCvFgMcJ0jUeT1Gk8frAw=";

    postFetch = ''
      rm -r $out/testdata/package_directory_mismatch/api
    '';
  };

  vendorHash = "sha256-KxDWd+fd30eOttNEB6kQDxc2Lnf5Rj2zTCohjyfjMnU=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mgechev/revive/cli.version=${finalAttrs.version}"
    "-X github.com/mgechev/revive/cli.builtBy=nix"
  ];

  meta = {
    description = "Fast, configurable, extensible, flexible, and beautiful linter for Go";
    mainProgram = "revive";
    homepage = "https://revive.run";
    downloadPage = "https://github.com/mgechev/revive";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
