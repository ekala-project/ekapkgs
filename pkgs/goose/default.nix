{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "goose";
  version = "3.27.2";

  src = fetchFromGitHub {
    owner = "pressly";
    repo = "goose";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4m/YYyQtz/Nj94vIUxChgmDsJVZqtzmp7qsSiuZVB38=";
  };

  proxyVendor = true;
  vendorHash = "sha256-8riGHomL3wKqBOPOzgE13jWYjJT03tqz1UMWR/01pcE=";

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
    maintainers = [ ];
  };
})
