{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Test-UseAllModules";
  version = "0.17";
  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/Test-UseAllModules-0.17.tar.gz";
    hash = "sha256-px8v6LlquL/Cdgqh0xNeoEmlsg3LEFRXt2mhGVx6JQk=";
  };
  meta = {
    description = "Do use_ok() for all the MANIFESTed modules";
  };
}
