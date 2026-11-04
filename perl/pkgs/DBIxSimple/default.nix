{
  buildPerlPackage,
  fetchurl,
  DBI,
}:
buildPerlPackage {
  pname = "DBIx-Simple";
  version = "1.37";

  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JU/JUERD/DBIx-Simple-1.37.tar.gz";
    hash = "sha256-RtMRqizgiQdAHFYRllhCbbsETFpA3nPZp7eb9QOQyuM=";
  };

  propagatedBuildInputs = [ DBI ];

  meta = {
    description = "Very complete easy-to-use OO interface to DBI";
  };
}
