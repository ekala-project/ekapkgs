{
  buildPerlPackage,
  fetchurl,
  TestNeeds,
}:
buildPerlPackage {
  pname = "JSON-MaybeXS";
  version = "1.004005";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/JSON-MaybeXS-1.004005.tar.gz";
    hash = "sha256-9ba8GfV55mtymfh0i4rD4XGTbcTn/LcqiiV6m9SCozE=";
  };
  buildInputs = [ TestNeeds ];
  meta = {
    description = "Use Cpanel::JSON::XS with a fallback to JSON::XS and JSON::PP";
  };
}
