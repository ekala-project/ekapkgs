{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {
  pname = "File-TreeCreate";
  version = "0.0.1";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/File-TreeCreate-0.0.1.tar.gz";
    hash = "sha256-V2hvEIQ76Br/rRha5BMXkLoMSvNtIQTW+2kSZSgFUmc=";
  };

  meta = {
    homepage = "http://metacpan.org/release/File-TreeCreate";
    description = "Recursively create a directory tree";
    license = lib.licenses.mit;
  };
}
