{
  buildPerlPackage,
  fetchurl,
  MailTools,
  MIMETypes,
  URI,
  IOStringy,
}:
buildPerlPackage {
  pname = "Mail-Message";
  version = "3.015";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MARKOV/Mail-Message-3.015.tar.gz";
    hash = "sha256-m2FGe9NiVVXeVOlpGlUXDhkEOaGJIxJ0BgmsBMjXoQ=";
  };
  propagatedBuildInputs = [
    MailTools
    MIMETypes
    URI
    IOStringy
  ];
  meta = {
    description = "Processing MIME messages";
  };
}
