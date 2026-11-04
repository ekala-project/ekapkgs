{
  buildPerlPackage,
  fetchurl,
  lib,
  NetCIDRLite,
  Socket6,
}:
buildPerlPackage {
  pname = "Net-Patricia";
  version = "1.24";

  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GR/GRUBER/Net-Patricia-1.24.tar.gz";
    hash = "sha256-2U9SCATiVBsc0g5zNmcgqXPK9d0tJiODj8jWOYr9fts=";
  };

  propagatedBuildInputs = [
    NetCIDRLite
    Socket6
  ];

  meta = {
    description = "Patricia Trie perl module for fast IP address lookups";
    license = lib.licenses.gpl2Plus;
  };
}
