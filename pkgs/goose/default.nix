{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "goose";
  version = "3.28.0";

  src = fetchFromGitHub {
    owner = "pressly";
    repo = "goose";
    rev = "v${finalAttrs.version}";
    hash = "sha256-V7kpDIJOyWB0O6uGQmxO1lgfdUYXIGJ3ycmXGu20H94=";
  };

  proxyVendor = true;
  vendorHash = "sha256-phtM6ClEwszIE7TQVXJbRLvSk0uSbng6h/pQsjHmjGU=";

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
