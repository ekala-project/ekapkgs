{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Parse-Syslog";
  version = "1.10";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DS/DSCHWEI/Parse-Syslog-1.10.tar.gz";
    hash = "sha256-ZZohRUQe822YNd7K+D2jCPzQP0kTjLPZCSjov8nxOdk=";
  };
  meta = {
    description = "Parse Unix syslog files";
  };
}
