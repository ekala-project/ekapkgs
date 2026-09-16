{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Clone-PP";
  version = "1.08";
  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEILB/Clone-PP-1.08.tar.gz";
    hash = "sha256-VyAwlKXYV0tqAJUejyOZtmb050+VEdnJ+1tFPV0R9Xg=";
  };
  meta = {
    description = "Recursively copy Perl datatypes";
  };
}
