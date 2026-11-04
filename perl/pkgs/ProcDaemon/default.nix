{
  buildPerlPackage,
  fetchurl,
  lib,
  ProcProcessTable,
}:
buildPerlPackage {
  pname = "Proc-Daemon";
  version = "0.23";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AK/AKREAL/Proc-Daemon-0.23.tar.gz";
    hash = "sha256-NMC4W3lItDHLq8l87lgINeUVzPQ7rb2DOesQlHQIm2k=";
  };
  buildInputs = [ ProcProcessTable ];
  meta = {
    description = "Run Perl program(s) as a daemon process";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
