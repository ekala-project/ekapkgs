{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module {
  pname = "mmark";
  version = "2.2.32";

  src = fetchFromGitHub {
    owner = "mmarkdown";
    repo = "mmark";
    rev = "158e9cca0280c58e205cb69b02bf33d7d826915e";
    hash = "sha256-OzmqtmAAsG3ncrTl2o9rhK75i1WIpDnph0YrY38SlU0=";
  };

  vendorHash = "sha256-GjR9cOGLB6URHQi+qcyNbP7rm0+y4wypvgUxgJzIgGQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Powerful markdown processor in Go geared towards the IETF";
    homepage = "https://github.com/mmarkdown/mmark";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    mainProgram = "mmark";
  };
}
