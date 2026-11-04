{
  buildPerlModule,
  fetchurl,
  lib,
  Test2Suite,
}:
buildPerlModule {
  pname = "Metrics-Any";
  version = "0.10";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PEVANS/Metrics-Any-0.10.tar.gz";
    hash = "sha256-qQ6t+civJKUWu5obZwYfZBhT+QuP7p/8JNK7lyDouZs=";
  };
  buildInputs = [ Test2Suite ];
  meta = {
    description = "Abstract collection of monitoring metrics";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
