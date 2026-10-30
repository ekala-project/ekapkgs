{
  buildPerlPackage,
  fetchurl,
  lib,
  DBI,
  DevelChecklib,
  libxcrypt,
  mysql80,
  openssl,
  zlib,
  zstd,
}:
buildPerlPackage {

  pname = "DBD-mysql";
  version = "5.010";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DV/DVEEDEN/DBD-mysql-5.010.tar.gz";
    hash = "sha256-LKL/Odk+idT3RG5fD68DgF6RZ+6bigS6fLJG4stG7uc=";
  };

  nativeBuildInputs = [
    mysql80.client # for mysql_config
  ];
  buildInputs = [
    DevelChecklib
    libxcrypt
    openssl
    zlib
    zstd
  ];
  propagatedBuildInputs = [ DBI ];

  doCheck = false; # require running database

  #  makeMakerFlags = "MYSQL_HOME=${mysql}";
  meta = {
    description = "MySQL driver for the Perl5 Database Interface (DBI)";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };

}
