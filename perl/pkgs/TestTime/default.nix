{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Test-Time";
  version = "0.092";

  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AN/ANATOFUZ/Test-Time-0.092.tar.gz";
    hash = "sha256-MNkPVM6ECJPHuiysKk0e7NTJzfgFkQxZXjronf1kRzg=";
  };

  meta = {
    description = "Overrides the time() and sleep() core functions for testing";
    homepage = "https://github.com/cho45/Test-Time";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
