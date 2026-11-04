{
  buildPerlPackage,
  fetchurl,
  lib,
  which,
  gnupg,
  MooXHandlesVia,
  MooXlate,
}:
buildPerlPackage {
  pname = "GnuPG-Interface";
  version = "1.03";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BP/BPS/GnuPG-Interface-1.03.tar.gz";
    hash = "sha256-WvVmMPD6wpDXJCGD9kSaoOAoKfRhHcYrxunps4CPGHo=";
  };
  nativeBuildInputs = [
    which
    gnupg
  ];
  propagatedBuildInputs = [
    MooXHandlesVia
    MooXlate
  ];
  meta = {
    description = "Supply object methods for interacting with GnuPG";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
