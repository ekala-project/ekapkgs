{
  buildPerlModule,
  fetchurl,
  LWP,
  TimeDate,
  URI,
}:
buildPerlModule {
  pname = "AWS-Signature4";
  version = "1.02";
  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LD/LDS/AWS-Signature4-1.02.tar.gz";
    hash = "sha256-ILvBbLNFT+XozzT+YfGpH+JsPxfkSf9mX8u7kqtEPr0=";
  };
  propagatedBuildInputs = [
    LWP
    TimeDate
    URI
  ];
  meta = {
    description = "Create a version4 signature for Amazon Web Services";
  };
}
