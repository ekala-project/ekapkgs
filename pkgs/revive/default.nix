{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "revive";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "mgechev";
    repo = "revive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RbWpGQ5rGkp2yBZ42if3hYyelWEZg+hlelw3WQ1VFRg=";

    postFetch = ''
      rm -r $out/testdata/package_directory_mismatch/api
    '';
  };

  vendorHash = "sha256-467AG0QMO565IBaUyZnqpUbLW6/J87x2b7zfbWqHecM=";

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
  };
})
