{
  buildPerlPackage,
  fetchurl,
  lib,
  ProcWaitStat,
}:
buildPerlPackage {
  pname = "mime-construct";
  version = "1.11";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RO/ROSCH/mime-construct-1.11.tar.gz";
    hash = "sha256-TNe7YbUdQRktFJjBBRqmpMzXWusJtx0uxwanCEpKkwM=";
  };
  outputs = [ "out" ];
  buildInputs = [ ProcWaitStat ];
  meta = {
    description = "Construct and optionally mail MIME messages";
    license = lib.licenses.gpl2Plus;
  };
}
