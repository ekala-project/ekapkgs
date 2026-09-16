{
  buildPerlPackage,
  fetchurl,
  db4,
}:
buildPerlPackage {
  pname = "BerkeleyDB";
  version = "0.65";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/BerkeleyDB-0.65.tar.gz";
    hash = "sha256-QQqonnIylB1JEGyeBI1jN0dVQ+wdIz6nzbcly1uWNQQ=";
  };
  preConfigure = ''
    echo "LIB = ${db4.out}/lib" > config.in
    echo "INCLUDE = ${db4.dev}/include" >> config.in
  '';
  meta = {
    description = "Perl extension for Berkeley DB version 2, 3, 4, 5 or 6";
  };
}
