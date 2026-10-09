{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "m3db";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "m3db";
    repo = "m3";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gTFMAhPG6X35TCp2ynd3HYFXki+MaDNJN62ymnoW+v4=";
  };

  vendorHash = "sha256-0UUzV5ZMJTu5wMPwK7EGcYw/EiD8fDTMcXgN0vDBGGA=";

  # Every main package is in a directory named "main", so subPackages would
  # collide on the output name; build each explicitly instead.
  subPackages = [ ];

  buildPhase = ''
    runHook preBuild
    mkdir -p $out/bin
    go build -o $out/bin/m3dbnode -ldflags "${lib.concatStringsSep " " finalAttrs.ldflags}" ./src/cmd/services/m3dbnode/main
    go build -o $out/bin/m3query -ldflags "${lib.concatStringsSep " " finalAttrs.ldflags}" ./src/cmd/services/m3query/main
    go build -o $out/bin/m3coordinator -ldflags "${lib.concatStringsSep " " finalAttrs.ldflags}" ./src/cmd/services/m3coordinator/main
    go build -o $out/bin/m3aggregator -ldflags "${lib.concatStringsSep " " finalAttrs.ldflags}" ./src/cmd/services/m3aggregator/main
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/m3db/m3/src/x/instrument.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Distributed, scalable time series database";
    homepage = "https://m3db.io";
    changelog = "https://github.com/m3db/m3/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "m3dbnode";
  };
})
