{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "DynaLoader-Functions";
  version = "0.004";
  src = fetchurl {
    url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/DynaLoader-Functions-0.004.tar.gz";
    hash = "sha256-Xo5CRnGgsvHZ3/MOX5kIfnVViA6115oyizH0zUmSmD0=";
  };
  meta = {
    description = "Deconstructed dynamic C library loading";
  };
}
