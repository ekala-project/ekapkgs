{
  buildPerlPackage,
  fetchurl,
  lib,
  EncodeLocale,
  FileListing,
  HTMLParser,
  HTTPCookieJar,
  HTTPCookies,
  HTTPDate,
  HTTPMessage,
  HTTPNegotiate,
  LWPMediaTypes,
  NetHTTP,
  TryTiny,
  URI,
  WWWRobotRules,
  HTTPDaemon,
  TestFatal,
  TestNeeds,
  TestRequiresInternet,
}:
buildPerlPackage {
  pname = "libwww-perl";
  version = "6.83";
  src = fetchurl {
    url = "mirror://cpan/authors/id/O/OA/OALDERS/libwww-perl-6.83.tar.gz";
    hash = "sha256-518PqdPG8Nr1pacvqfixycDSPjqEqFIsy0+DUjK5VQU=";
  };
  buildInputs = [
    HTTPDaemon
    TestFatal
    TestNeeds
    TestRequiresInternet
  ];
  propagatedBuildInputs = [
    EncodeLocale
    FileListing
    HTMLParser
    HTTPCookieJar
    HTTPCookies
    HTTPDate
    HTTPMessage
    HTTPNegotiate
    LWPMediaTypes
    NetHTTP
    TryTiny
    URI
    WWWRobotRules
  ];
  meta = {
    homepage = "https://github.com/libwww-perl/libwww-perl";
    description = "World-Wide Web library for Perl";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
