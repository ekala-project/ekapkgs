{
  buildPerlPackage,
  fetchurl,
  MailTools,
  TestDeep,
}:
buildPerlPackage {
  pname = "MIME-tools";
  version = "5.509";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DS/DSKOLL/MIME-tools-5.509.tar.gz";
    hash = "sha256-ZFefDJI9gdmiGUWG5Hw0dVGeJkbktcECqJIHWfrPaXM=";
  };
  propagatedBuildInputs = [ MailTools ];
  buildInputs = [ TestDeep ];
  meta = {
    description = "Tools to manipulate MIME messages";
  };
}
