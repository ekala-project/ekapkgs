{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Class-Trigger";
  version = "0.15";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Class-Trigger-0.15.tar.gz";
    hash = "sha256-t6h41E3qZ9ZN8soYAg2dhoqVWW3r0W8aJkh0IJMysH8=";
  };
  meta = {
    description = "Mixin to add / call inheritable triggers";
  };
}
