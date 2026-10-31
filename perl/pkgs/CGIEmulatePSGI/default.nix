{
  buildPerlPackage,
  fetchurl,
  TestRequires,
  CGI,
}:
buildPerlPackage {
  pname = "CGI-Emulate-PSGI";
  version = "0.23";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/CGI-Emulate-PSGI-0.23.tar.gz";
    hash = "sha256-3VtsNT8I+6EA2uCZBChPf3P4Mo0x9qZ7LBNvrXKNFYs=";
  };
  buildInputs = [ TestRequires ];
  propagatedBuildInputs = [ CGI ];
  meta = {
    description = "PSGI adapter for CGI";
  };
}
