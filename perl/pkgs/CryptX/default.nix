{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "CryptX";
  version = "0.089";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIK/CryptX-0.089.tar.gz";
    hash = "sha256-8Od8few5ZxqFnzjfJdK/8wARvPVfLZ0PIMJrekR8n7Q=";
  };
  meta = {
    description = "Cryptographic toolkit";
  };
}
