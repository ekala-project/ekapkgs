{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cadvisor";
  version = "0.61.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4pl6sN/BepCEo59VQ8x0ODBm1oRoWZ4Q1ayORXsFHZ4=";
  };

  modRoot = "./cmd";

  vendorHash = "sha256-ECLpq1vk2EqJo0DcKvCqLI7Bq3k8L8ji+wuC9It6jGw=";

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
