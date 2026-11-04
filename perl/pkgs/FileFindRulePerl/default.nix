{
  buildPerlPackage,
  fetchurl,
  lib,
  FileFindRule,
  ParamsUtil,
}:
buildPerlPackage {
  pname = "File-Find-Rule-Perl";
  version = "1.16";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/File-Find-Rule-Perl-1.16.tar.gz";
    hash = "sha256-rhiGBQ2cohIjwHPihwq9yA3DDj9VKJoRw32jggqDIf8=";
  };

  propagatedBuildInputs = [
    FileFindRule
    ParamsUtil
  ];

  meta = {
    description = "Common rules for searching for Perl things";
    homepage = "https://github.com/karenetheridge/File-Find-Rule-Perl";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
