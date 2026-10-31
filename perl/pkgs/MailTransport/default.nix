{
  buildPerlPackage,
  fetchurl,
  MailMessage,
}:
buildPerlPackage {
  pname = "Mail-Transport";
  version = "3.005";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MARKOV/Mail-Transport-3.005.tar.gz";
    hash = "sha256-0Ny5P3BcEoXYCONN59htvijR7WaqKn3oMPZlH8NRlqM=";
  };
  propagatedBuildInputs = [ MailMessage ];
  meta = {
    description = "Email message exchange";
  };
}
