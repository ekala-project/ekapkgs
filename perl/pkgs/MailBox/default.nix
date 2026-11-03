{
  buildPerlPackage,
  fetchurl,
  DevelGlobalDestruction,
  FileRemove,
  Later,
  MailTransport,
}:
buildPerlPackage {
  pname = "Mail-Box";
  version = "3.010";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MARKOV/Mail-Box-3.010.tar.gz";
    hash = "sha256-rhlPolDFRcm5FT4/tRA8qyn3nPKs1On9dc7FMiAalWQ=";
  };
  propagatedBuildInputs = [
    DevelGlobalDestruction
    FileRemove
    Later
    MailTransport
  ];
  meta = {
    description = "Manage a mailbox, a folder with messages";
  };
}
