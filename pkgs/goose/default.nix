{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "goose";
  version = "3.27.3";

  src = fetchFromGitHub {
    owner = "pressly";
    repo = "goose";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CSS0OtC4/EeQD7PGin64U0Fag2z490RQ7CKNBRyp8f8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-opO6G9Fdyt27GlWyaB/6J1xhm3wTgH9Xc/FYcLcqBVs=";

  postPatch = ''
    rm -r tests/gomigrations
  '';

  subPackages = [
    "cmd/goose"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  doCheck = false;

  meta = {
    description = "Database migration tool which supports SQL migrations and Go functions";
    homepage = "https://pressly.github.io/goose/";
    license = lib.licenses.bsd3;
    mainProgram = "goose";
  };
})
