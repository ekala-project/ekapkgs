{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Class-Accessor";
  version = "0.51";
  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KA/KASEI/Class-Accessor-0.51.tar.gz";
    hash = "sha256-vxKj5d5aLG6KRHs2T09aBQv3RiTFbjFQIq55kv8vQRw=";
  };
}
