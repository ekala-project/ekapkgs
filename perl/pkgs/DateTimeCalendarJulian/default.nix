{
  buildPerlPackage,
  fetchurl,
  DateTime,
}:
buildPerlPackage {
  pname = "DateTime-Calendar-Julian";
  version = "0.107";
  src = fetchurl {
    url = "mirror://cpan/authors/id/W/WY/WYANT/DateTime-Calendar-Julian-0.107.tar.gz";
    hash = "sha256-/LK0JIRLsTvK1GsceqI5taCbqyVW9TvR8n+tkMJg0z0=";
  };
  propagatedBuildInputs = [ DateTime ];
}
