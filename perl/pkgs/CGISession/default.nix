{
  buildPerlModule,
  fetchurl,
  lib,
  CGI,
  CryptSysRandom,
}:
buildPerlModule {
  pname = "CGI-Session";
  version = "4.49";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MARKSTOS/CGI-Session-4.49.tar.gz";
    hash = "sha256-X9iKgwo19UUmeH8DauXkp9FLYcQUzSmthjG/RuaXEgc=";
  };

  propagatedBuildInputs = [
    CGI
    CryptSysRandom
  ];

  meta = {
    description = "Persistent session data in CGI applications";
    license = lib.licenses.artistic1;
  };
}
