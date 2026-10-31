{
  buildPerlPackage,
  fetchurl,
  lib,
  PerlMinimumVersion,
}:
buildPerlPackage {
  pname = "Test-MinimumVersion";
  version = "0.101083";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Test-MinimumVersion-0.101083.tar.gz";
    hash = "sha256-MqHrzYA/oQ7vylU7w87dQ1lqdZ3Dl1revSJoiCPDauo=";
  };
  propagatedBuildInputs = [ PerlMinimumVersion ];
  meta = {
    description = "Does your code require newer perl than you think";
    homepage = "https://github.com/rjbs/Test-MinimumVersion";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
