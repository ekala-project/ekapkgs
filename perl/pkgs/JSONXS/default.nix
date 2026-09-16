{
  buildPerlPackage,
  fetchurl,
  lib,
  TypesSerialiser,
  CanaryStability,
}:
buildPerlPackage {
  pname = "JSON-XS";
  version = "4.03";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/ML/MLEHMANN/JSON-XS-4.03.tar.gz";
    hash = "sha256-UVU29F8voafojIgkUzdY0BIdJnq5y0U6G1iHyKVrkGg=";
  };
  patches = [ ./CVE-2025-40928.patch ];
  propagatedBuildInputs = [ TypesSerialiser ];
  buildInputs = [ CanaryStability ];
  meta = {
    description = "JSON serialising/deserialising, done correctly and fast";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "json_xs";
  };
}
