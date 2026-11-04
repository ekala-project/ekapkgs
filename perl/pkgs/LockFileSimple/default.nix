{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "LockFile-Simple";
  version = "0.208";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SC/SCHWIGON/lockfile-simple/LockFile-Simple-0.208.tar.gz";
    hash = "sha256-Rcd4lrKloKRfYgKm+BP0N/+LKD+EocYNDE83MIAq86I=";
  };

  meta = {
    description = "Simple file locking scheme";
    license = with lib.licenses; [
      artistic1
      gpl2Plus
    ];
  };
}
