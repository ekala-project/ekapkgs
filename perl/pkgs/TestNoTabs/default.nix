{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Test-NoTabs";
  version = "2.02";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Test-NoTabs-2.02.tar.gz";
    hash = "sha256-+3XGo4ch8BaeEcHn2+UyntchaIWgsBEj80LdhtM1YDA=";
  };

  meta = {
    description = "Check the presence of tabs in your project";
    homepage = "https://github.com/karenetheridge/Test-NoTabs";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
