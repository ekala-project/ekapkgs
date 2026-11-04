{
  buildPerlPackage,
  fetchurl,
  lib,
  MooseXTypes,
}:
buildPerlPackage {
  pname = "MooseX-Types-Stringlike";
  version = "0.003";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/MooseX-Types-Stringlike-0.003.tar.gz";
    hash = "sha256-LuNJ7FxSmm80f0L/ZA5HskVWS5PMowXfY8eCH1tVzxk=";
  };
  propagatedBuildInputs = [ MooseXTypes ];
  meta = {
    description = "Moose type constraints for strings or string-like objects";
    license = lib.licenses.asl20;
  };
}
