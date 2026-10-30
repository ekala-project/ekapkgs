{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {

  pname = "YAML-Syck";
  version = "1.47";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TO/TODDR/YAML-Syck-1.47.tar.gz";
    hash = "sha256-ZyGWyhwCHjxo9LX3tK7DBa1HG7v0SMU8fkADTW67fh0=";
  };
  env.NIX_CFLAGS_COMPILE = "-std=gnu11";
  meta = {
    description = "Fast, lightweight YAML loader and dumper";
    homepage = "https://github.com/toddr/YAML-Syck";
    license = lib.licenses.mit;
  };

}
