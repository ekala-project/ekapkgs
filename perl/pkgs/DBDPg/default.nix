{
  buildPerlPackage,
  fetchurl,
  fetchpatch,
  lib,
  DBI,
  postgresql,
}:
buildPerlPackage {

  pname = "DBD-Pg";
  version = "3.17.0";

  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TU/TURNSTEP/DBD-Pg-3.17.0.tar.gz";
    hash = "sha256-jZANTA50nzchh1KmZh+w01V6sfzMjeo4TLWHw4LeIZs=";
  };

  patches = [
    # Fix build with gcc15
    # https://github.com/bucardo/dbdpg/pull/148
    (fetchpatch {
      name = "perl-dbdpg-fix-c23-compliance.patch";
      url = "https://github.com/bucardo/dbdpg/commit/8da04f9169d017469e3a12f08322e6bd88e8f239.patch";
      hash = "sha256-MpVpaZoRgN1ABk6F6hFZvo9IkQJX2frHDygOTa0wics=";
    })
  ];

  buildInputs = [ postgresql ];
  propagatedBuildInputs = [ DBI ];

  nativeBuildInputs = [ postgresql.pg_config ];

  # tests freeze in a sandbox

  meta = {
    description = "DBI PostgreSQL interface";
    homepage = "https://search.cpan.org/dist/DBD-Pg";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    platforms = lib.platforms.unix;
  };

}
