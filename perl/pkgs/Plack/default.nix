{
  buildPerlPackage,
  fetchurl,
  lib,
  FileShareDirInstall,
  HTTPRequestAsCGI,
  LWP,
  TestRequires,
  TestSharedFork,
  TestTCP,
  ApacheLogFormatCompiler,
  CookieBaker,
  DevelStackTraceAsHTML,
  FileShareDir,
  FilesysNotifySimple,
  HTTPEntityParser,
  HTTPHeadersFast,
  HTTPMessage,
  TryTiny,
}:
buildPerlPackage {
  pname = "Plack";
  version = "1.0053";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Plack-1.0053.tar.gz";
    hash = "sha256-QPxEA0wWTpr3DdCP++5AjCQwLsDbMQ0pAd9xdTuxZ9o=";
  };
  buildInputs = [
    FileShareDirInstall
    HTTPRequestAsCGI
    LWP
    TestRequires
    TestSharedFork
    TestTCP
  ];
  propagatedBuildInputs = [
    ApacheLogFormatCompiler
    CookieBaker
    DevelStackTraceAsHTML
    FileShareDir
    FilesysNotifySimple
    HTTPEntityParser
    HTTPHeadersFast
    HTTPMessage
    TryTiny
  ];
  meta = {
    description = "Perl Superglue for Web frameworks and Web Servers (PSGI toolkit)";
    homepage = "https://github.com/plack/Plack";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "plackup";
  };
}
