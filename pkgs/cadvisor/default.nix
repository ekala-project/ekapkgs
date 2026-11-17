{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cadvisor";
  version = "0.61.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9Jvd6kW6r7ZTMWnA8GhUejcGepU7lpyhcFoUuUhOxUU=";
  };

  modRoot = "./cmd";

  vendorHash = "sha256-QZ7ktewF8eZEmOxUD7S3NyhTPrhMoXH8tXx3LbMlFwM=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/google/cadvisor/version.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/{cmd,cadvisor}
    rm $out/bin/example
  '';

  meta = {
    description = "Analyzes resource usage and performance characteristics of running docker containers";
    mainProgram = "cadvisor";
    homepage = "https://github.com/google/cadvisor";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
})
