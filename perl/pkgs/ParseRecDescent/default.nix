{ buildPerlModule, fetchurl }:
buildPerlModule {
  pname = "Parse-RecDescent";
  version = "1.967015";
  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JT/JTBRAUN/Parse-RecDescent-1.967015.tar.gz";
    hash = "sha256-GUMzaky1TxeIpzPwgnwMVdtDENXq4V5UJjnJ3YVlbjc=";
  };
}
