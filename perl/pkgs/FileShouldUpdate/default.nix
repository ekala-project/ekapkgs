{
  buildPerlModule,
  fetchurl,
  lib,
  PathTiny,
}:
buildPerlModule {
  pname = "File-ShouldUpdate";
  version = "0.2.1";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/File-ShouldUpdate-0.2.1.tar.gz";
    hash = "sha256-r1k1mNBvHCG63TrnQb8LRQbOJl7ImVDGCj8+cQbes+I=";
  };
  buildInputs = [ PathTiny ];
  meta = {
    description = "Can be used to determine if files should be updated based on the mtime timestamps of their dependencies";
    homepage = "https://github.com/shlomif/perl-File-ShouldUpdate";
    license = lib.licenses.mit;
  };
}
