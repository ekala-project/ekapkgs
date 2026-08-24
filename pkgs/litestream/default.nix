{
  buildGo126Module,
  fetchFromGitHub,
  lib,
}:
buildGo126Module (finalAttrs: {
  pname = "litestream";
  version = "0.5.16";

  src = fetchFromGitHub {
    owner = "benbjohnson";
    repo = "litestream";
    rev = "v${finalAttrs.version}";
    hash = "sha256-06ZQbOol87HZVaBFOyYbSasl3eHFcdwrYTnmProg9uY=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-xoJwxmQzWSQ055+W1I+hNyEcB3bfShCoAfdMU4Pckjc=";
  meta = {
    description = "Streaming replication for SQLite";
    mainProgram = "litestream";
    license = lib.licenses.asl20;
    homepage = "https://litestream.io/";
    maintainers = [ ];
  };
})
