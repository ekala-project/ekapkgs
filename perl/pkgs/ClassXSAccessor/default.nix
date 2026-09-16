{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Class-XSAccessor";
  version = "1.19";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SM/SMUELLER/Class-XSAccessor-1.19.tar.gz";
    hash = "sha256-mcVrOV8SOa8ZkB8v7rEl2ey041Gg2A2qlSkhGkcApvI=";
  };
  meta = {
    description = "Generate fast XS accessors without runtime compilation";
  };
}
