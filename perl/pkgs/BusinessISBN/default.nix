{
  buildPerlPackage,
  fetchurl,
  BusinessISBNData,
}:
buildPerlPackage {
  pname = "Business-ISBN";
  version = "3.008";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BD/BDFOY/Business-ISBN-3.008.tar.gz";
    hash = "sha256-GcSh1NmaDddpWpAZKxNASg4+7r7fy+l6AgLjayOMDmk=";
  };
  propagatedBuildInputs = [ BusinessISBNData ];
}
