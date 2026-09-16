{
  buildPerlPackage,
  fetchurl,
  ClassInspector,
  IOSessionData,
  LWPProtocolHttps,
  TaskWeaken,
  XMLParser,
  TestWarn,
  XMLParserLite,
  HTTPDaemon,
}:
buildPerlPackage {
  pname = "SOAP-Lite";
  version = "1.27";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PH/PHRED/SOAP-Lite-1.27.tar.gz";
    hash = "sha256-41kQa6saRaFgRKTC+ASfrQNOXe0VF5kLybX42G3d0wE=";
  };
  propagatedBuildInputs = [
    ClassInspector
    IOSessionData
    LWPProtocolHttps
    TaskWeaken
    XMLParser
  ];
  buildInputs = [
    TestWarn
    XMLParserLite
  ];
  nativeCheckInputs = [ HTTPDaemon ];
  meta = {
    description = "Perl's Web Services Toolkit";
  };
}
