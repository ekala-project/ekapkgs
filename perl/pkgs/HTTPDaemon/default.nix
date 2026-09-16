{
  buildPerlModule,
  fetchurl,
  ModuleBuildTiny,
  TestNeeds,
  HTTPMessage,
}:
buildPerlModule {
  pname = "HTTP-Daemon";
  version = "6.17";
  src = fetchurl {
    url = "mirror://cpan/authors/id/O/OA/OALDERS/HTTP-Daemon-6.17.tar.gz";
    hash = "sha256-FigVgMQOIxCNAoQ0aYtdfVNje/kEyd+CJIHiU8vskgw=";
  };
  buildInputs = [
    ModuleBuildTiny
    TestNeeds
  ];
  propagatedBuildInputs = [ HTTPMessage ];
  meta = {
    description = "Simple http server class";
  };
}
