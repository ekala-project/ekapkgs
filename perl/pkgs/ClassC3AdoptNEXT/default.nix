{
  buildPerlModule,
  fetchurl,
  lib,
  ModuleBuildTiny,
  TestException,
  MROCompat,
}:
buildPerlModule {
  pname = "Class-C3-Adopt-NEXT";
  version = "0.14";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Class-C3-Adopt-NEXT-0.14.tar.gz";
    hash = "sha256-hWdiJarbduhmamq+LgZZ1A60WBrWOFsXDupOHWvzS/c=";
  };

  buildInputs = [
    ModuleBuildTiny
    TestException
  ];

  propagatedBuildInputs = [ MROCompat ];

  meta = {
    description = "Make NEXT suck less";
    homepage = "https://github.com/karenetheridge/Class-C3-Adopt-NEXT";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
