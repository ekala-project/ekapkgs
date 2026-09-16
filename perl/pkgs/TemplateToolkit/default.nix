{
  buildPerlPackage,
  fetchurl,
  lib,
  AppConfig,
  CGI,
  TestLeakTrace,
}:
buildPerlPackage {
  pname = "Template-Toolkit";
  version = "3.101";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AB/ABW/Template-Toolkit-3.101.tar.gz";
    hash = "sha256-0qMt1sIeSzfGqT34CHyp6IDPrmE6Pl766jB7C9yu21g=";
  };
  propagatedBuildInputs = [ AppConfig ];
  buildInputs = [
    CGI
    TestLeakTrace
  ];
  meta = {
    description = "Comprehensive template processing system";
    homepage = "http://www.template-toolkit.org";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
