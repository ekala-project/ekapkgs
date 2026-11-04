{
  buildPerlPackage,
  fetchurl,
  fetchpatch,
  lib,
  perl,
  sqlite,
  DBI,
}:
buildPerlPackage {
  pname = "DBD-SQLite";
  version = "1.74";

  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/DBD-SQLite-1.74.tar.gz";
    hash = "sha256-iZSZfYS5/rRUd5X3h0bGYfty48tqJdvdeJtzH1aIpN0=";
  };

  propagatedBuildInputs = [ DBI ];

  buildInputs = [ sqlite ];

  patches = [
    (fetchpatch {
      name = "sqlite-3.37-compat.patch";
      url = "https://github.com/DBD-SQLite/DBD-SQLite/commit/ba4f472e7372dbf453444c7764d1c342e7af12b8.patch";
      hash = "sha256-nn4JvaIGlr2lUnUC+0ABe9AFrRrC5bfdTQiefo0Pjwo=";
    })
  ];

  makeMakerFlags = [
    "SQLITE_INC=${sqlite.dev}/include"
    "SQLITE_LIB=${sqlite.out}/lib"
  ];

  postInstall = ''
    rm -rf $out/${perl.libPrefix}/*/*/auto/share
  '';

  preCheck = "rm t/65_db_config.t";

  meta = {
    description = "Self Contained SQLite RDBMS in a DBI Driver";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    platforms = lib.platforms.unix;
  };
}
