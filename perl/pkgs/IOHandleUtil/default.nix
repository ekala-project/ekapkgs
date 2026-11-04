{
  buildPerlModule,
  fetchurl,
  lib,
  IOString,
  SubExporter,
  asa,
  ModuleBuildTiny,
}:
buildPerlModule {
  pname = "IO-Handle-Util";
  version = "0.02";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/IO-Handle-Util-0.02.tar.gz";
    hash = "sha256-jblmqRPaxORkIwcCqiIr84r+ISGT5ja8DzzGUbrezO4=";
  };

  propagatedBuildInputs = [
    IOString
    SubExporter
    asa
  ];

  buildInputs = [ ModuleBuildTiny ];

  meta = {
    description = "Functions for working with IO::Handle like objects";
    homepage = "https://github.com/karenetheridge/IO-Handle-Util";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
