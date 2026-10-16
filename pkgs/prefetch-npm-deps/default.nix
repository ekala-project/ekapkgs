{
  lib,
  rustPlatform,
  makeWrapper,
  pkg-config,
  curl,
  tar,
  gzip,
}:

rustPlatform.buildRustPackage {
  pname = "prefetch-npm-deps";
  version = (lib.importTOML ./Cargo.toml).package.version;

  src = lib.cleanSourceWith {
    src = ./.;
    filter =
      name: type:
      let
        name' = baseNameOf name;
      in
      name' != "default.nix" && name' != "target";
  };

  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];
  buildInputs = [ curl ];

  postInstall = ''
    wrapProgram "$out/bin/prefetch-npm-deps" --prefix PATH : ${
      lib.makeBinPath [
        tar
        gzip
      ]
    }
  '';

  meta = {
    description = "Prefetch dependencies from npm (for use with fetchNpmDeps)";
    mainProgram = "prefetch-npm-deps";
    license = lib.licenses.mit;
  };
}
