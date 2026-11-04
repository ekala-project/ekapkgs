{
  buildPerlPackage,
  fetchurl,
  lib,
  DateTime,
}:
buildPerlPackage rec {
  pname = "DateTime-Format-RFC3339";
  version = "1.2.0";
  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IK/IKEGAMI/DateTime-Format-RFC3339-v${version}.tar.gz";
    hash = "sha256-E27hIkwxxuAXaSqfXlb9tPcKlfRq7DrYVdN4PeNaDfc=";
  };
  propagatedBuildInputs = [ DateTime ];
  meta = {
    description = "Parse and format RFC3339 datetime strings";
    homepage = "https://search.cpan.org/dist/DateTime-Format-RFC3339";
    license = lib.licenses.cc0;
  };
}
