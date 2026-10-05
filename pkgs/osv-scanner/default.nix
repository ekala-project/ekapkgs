{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "osv-scanner";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "osv-scanner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w/cYCq5hp6b5HOkwPugWDWNXIZIJ0asgjMZeqSXBkOs=";
  };

  vendorHash = "sha256-hqFh8k3HXD9H4E695Wd/OvU0fz9mbZJne/lJ8+akhK8=";

  subPackages = [
    "cmd/osv-scanner"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/google/osv-scanner/internal/version.OSVVersion=${finalAttrs.version}"
    "-X=main.commit=n/a"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  doCheck = false;

  meta = {
    description = "Vulnerability scanner written in Go which uses the data provided by https://osv.dev";
    mainProgram = "osv-scanner";
    homepage = "https://github.com/google/osv-scanner";
    changelog = "https://github.com/google/osv-scanner/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
  };
})
