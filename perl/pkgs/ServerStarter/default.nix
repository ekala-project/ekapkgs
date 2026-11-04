{
  buildPerlModule,
  fetchurl,
  lib,
  TestRequires,
  TestSharedFork,
  TestTCP,
}:
buildPerlModule {
  pname = "Server-Starter";
  version = "0.35";

  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KA/KAZUHO/Server-Starter-0.35.tar.gz";
    hash = "sha256-Z23A1s/0ZIU4Myxjwy+4itCe2GghPqnmLj8Z+tQbnEA=";
  };

  buildInputs = [
    TestRequires
    TestSharedFork
    TestTCP
  ];

  doCheck = false; # Tests are slow and unstable

  meta = {
    description = "Superdaemon for hot-deploying server programs";
    homepage = "https://github.com/kazuho/p5-Server-Starter";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "start_server";
  };
}
