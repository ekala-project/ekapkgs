{
  buildPerlPackage,
  fetchurl,
  lib,
  mariadb-connector-c,
  DevelChecklib,
  TestDeep,
  TestDistManifest,
  TestPod,
  DBI,
}:
buildPerlPackage {
  pname = "DBD-MariaDB";
  version = "1.23";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PA/PALI/DBD-MariaDB-1.23.tar.gz";
    hash = "sha256-DQx2xmDd1VVw5I8+L96o9iGmmsDtSBkOjPyvy16bhZ0=";
  };
  nativeBuildInputs = [ mariadb-connector-c ];
  buildInputs = [
    mariadb-connector-c
    DevelChecklib
    TestDeep
    TestDistManifest
    TestPod
  ];
  propagatedBuildInputs = [ DBI ];
  strictDeps = true;
  meta = {
    description = "MariaDB and MySQL driver for the Perl5 Database Interface (DBI)";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
