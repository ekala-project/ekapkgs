{
  buildGo126Module,
  fetchFromGitHub,
  lib,
}:

buildGo126Module (finalAttrs: {
  pname = "revive";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "mgechev";
    repo = "revive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7uYNDIhl7iyI2cko+KqGBgL24b8mjNnjt2tZP77nNmg=";

    postFetch = ''
      rm -r $out/testdata/package_directory_mismatch/api
    '';
  };

  vendorHash = "sha256-2JYqTgJy97qUgwLxhtluapWArH28wd+XnJsl9iFtddk=";

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
