{
  buildPerlModule,
  fetchurl,
  URI,
}:
buildPerlModule {
  pname = "URI-Find";
  version = "20160806";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MS/MSCHWERN/URI-Find-20160806.tar.gz";
    hash = "sha256-4hOkJaUbX1UyQhHzeQnXh0nQus3qJZulGphV0NGWY9Y=";
  };
  propagatedBuildInputs = [ URI ];
  meta = {
    description = "Find URIs in arbitrary text";
  };
}
