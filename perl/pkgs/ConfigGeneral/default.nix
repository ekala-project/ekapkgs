{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Config-General";
  version = "2.65";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TL/TLINDEN/Config-General-2.65.tar.gz";
    hash = "sha256-TW1XVL46nzCQaDbwzBDlVMiDLhTnoTQe+xWwXXBvxY8=";
  };
  meta = {
    description = "Generic Config Module";
  };
}
