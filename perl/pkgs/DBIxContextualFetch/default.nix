{
  buildPerlPackage,
  fetchurl,
  DBI,
}:
buildPerlPackage {
  pname = "DBIx-ContextualFetch";
  version = "1.03";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TM/TMTM/DBIx-ContextualFetch-1.03.tar.gz";
    hash = "sha256-heL4Bb/IHNc4wpQxayelFTlwNvOXoP8cbI11TDhTAwY=";
  };
  propagatedBuildInputs = [ DBI ];
  meta = {
    description = "Add contextual fetches to DBI";
  };
}
