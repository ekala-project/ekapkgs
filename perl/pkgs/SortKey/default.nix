{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Sort-Key";
  version = "1.33";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SA/SALVA/Sort-Key-1.33.tar.gz";
    hash = "sha256-7WpMz6sJTJzRZPVkAk6YvSHZT0MSzKxNYkbSKzQIGs8=";
  };
}
