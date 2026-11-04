{
  buildPerlPackage,
  fetchurl,
  lib,
  CGI,
  CacheCache,
  ClassContainer,
  ExceptionClass,
  LogAny,
  TestDeep,
}:
buildPerlPackage {
  pname = "HTML-Mason";
  version = "1.60";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/HTML-Mason-1.60.tar.gz";
    hash = "sha256-qgu9WmtjxiyJVfjFXsCF43DXktZSZrbDtcXweIu8d+Y=";
  };

  buildInputs = [ TestDeep ];

  propagatedBuildInputs = [
    CGI
    CacheCache
    ClassContainer
    ExceptionClass
    LogAny
  ];

  meta = {
    description = "High-performance, dynamic web site authoring system";
    homepage = "https://metacpan.org/release/HTML-Mason";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
