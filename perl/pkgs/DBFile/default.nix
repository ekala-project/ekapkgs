{
  buildPerlPackage,
  fetchurl,
  db,
}:
buildPerlPackage {
  pname = "DB_File";
  version = "1.859";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/DB_File-1.859.tar.gz";
    hash = "sha256-VnTg0s0LBgxNElNnDqAixk2EKlUlf5647bGcD1PiVlw=";
  };
  preConfigure = ''
    cat > config.in <<EOF
    PREFIX = size_t
    HASH = u_int32_t
    LIB = ${db.out}/lib
    INCLUDE = ${db.dev}/include
    EOF
  '';
  meta = {
    description = "Perl5 access to Berkeley DB version 1.x";
  };
}
