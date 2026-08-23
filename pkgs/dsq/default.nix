{
  lib,
  fetchFromGitHub,
  buildGo126Module,
}:

buildGo126Module (finalAttrs: {
  pname = "dsq";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "multiprocessio";
    repo = "dsq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FZBJe+2y4HV3Pgeap4yvD0a8M/j+6pAJEFpoQVVE1ec=";
  };

  vendorHash = "sha256-MbBR+OC1OGhZZGcZqc+Jzmabdc5ZfFEwzqP5YMrj6mY=";

  ldflags = [
    "-X"
    "main.Version=${finalAttrs.version}"
  ];

  doCheck = false;

  meta = {
    mainProgram = "dsq";
    description = "Commandline tool for running SQL queries against JSON, CSV, Excel, Parquet, and more";
    homepage = "https://github.com/multiprocessio/dsq";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
