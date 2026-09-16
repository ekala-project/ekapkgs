{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "autovivification";
  version = "0.18";
  src = fetchurl {
    url = "mirror://cpan/authors/id/V/VP/VPIT/autovivification-0.18.tar.gz";
    hash = "sha256-LZmXVoUkKYDQqZBPY5FEwFnW7OFYme/eSst0LTJT8QU=";
  };
  meta.description = "Lexically disable autovivification";
}
