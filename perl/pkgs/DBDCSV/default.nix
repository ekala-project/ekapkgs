{
  buildPerlPackage,
  fetchurl,
  fetchpatch2,
  lib,
  DBI,
  SQLStatement,
  TextCSV_XS,
}:
buildPerlPackage {
  pname = "DBD-CSV";
  version = "0.62";
  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HM/HMBRAND/DBD-CSV-0.62.tgz";
    hash = "sha256-0/EVD+IGfA49FJWHZeqNQZWDSY+WMTawQC2qkwvJMOM=";
  };
  patches = [
    (fetchpatch2 {
      url = "https://github.com/perl5-dbi/DBD-CSV/commit/ae091790398088a66b22fa572856bfeb4db4c78a.patch?full_index=1";
      excludes = [ "ChangeLog" ];
      hash = "sha256-eZdCNSi3YJrZdZcK/8nFx5Q4rB89b0ynKemupvKrfys=";
    })
  ];
  propagatedBuildInputs = [
    DBI
    SQLStatement
    TextCSV_XS
  ];
  meta = {
    description = "DBI driver for CSV files";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
