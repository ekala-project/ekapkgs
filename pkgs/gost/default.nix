{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "gost";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "go-gost";
    repo = "gost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+g8YjOuH1WKfEYPLbrKB2YIHnY7HXJv0rQfxiL/jdQI=";
  };

  vendorHash = "sha256-lEPJpOXyPiMbFEbVlMGdhBGRYj5JTx2zun7YmX19r4k=";

  # Based on ldflags in upstream's .goreleaser.yaml
  ldflags = [
    "-s"
    "-X main.version=v${finalAttrs.version}"
  ];

  subPackages = [ "cmd/gost" ];

  __darwinAllowLocalNetworking = true;

  # e2e tests require Docker
  doCheck = false;

  versionCheckProgramArg = "-V";

  meta = {
    description = "Simple tunnel written in golang";
    homepage = "https://github.com/go-gost/gost";
    license = lib.licenses.mit;
    mainProgram = "gost";
  };
})
