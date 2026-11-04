{
  buildPerlModule,
  fetchurl,
  lib,
  IOString,
  ModuleBuildTiny,
  TestDeep,
  TestFatal,
  TestSharedFork,
  TestTCP,
  IOSocketTimeout,
  TryTiny,
}:
buildPerlModule {
  pname = "Redis";
  version = "2.000";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAMS/Redis-2.000.tar.gz";
    hash = "sha256-FMuJl5chJhW06T+Rbcva+0jQHF6qsgOP5ssXm/lcb+s=";
  };

  buildInputs = [
    IOString
    ModuleBuildTiny
    TestDeep
    TestFatal
    TestSharedFork
    TestTCP
  ];

  propagatedBuildInputs = [
    IOSocketTimeout
    TryTiny
  ];

  meta = {
    description = "Perl binding for Redis database";
    homepage = "https://github.com/PerlRedis/perl-redis";
    license = lib.licenses.artistic2;
  };
}
