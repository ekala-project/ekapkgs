{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Object-Realize-Later";
  version = "0.21";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MARKOV/Object-Realize-Later-0.21.tar.gz";
    hash = "sha256-j3uWQMyONOqSvPbAEEmgPBReDrRuViJ14o3d06jW2Nk=";
  };

  meta = {
    description = "Delayed creation of objects";
  };
}
