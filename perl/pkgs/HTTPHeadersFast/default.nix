{
  buildPerlModule,
  fetchurl,
  lib,
  ModuleBuildTiny,
  TestRequires,
  HTTPDate,
}:
buildPerlModule {
  pname = "HTTP-Headers-Fast";
  version = "0.22";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TO/TOKUHIROM/HTTP-Headers-Fast-0.22.tar.gz";
    hash = "sha256-zEMdtoSW3YhNtLwMC3ESwfSk8dxoxPWjyqdXoedIG0g=";
  };
  buildInputs = [
    ModuleBuildTiny
    TestRequires
  ];
  propagatedBuildInputs = [ HTTPDate ];
  meta = {
    description = "Faster implementation of HTTP::Headers";
    homepage = "https://github.com/tokuhirom/HTTP-Headers-Fast";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
