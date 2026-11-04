{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "CPAN-Changes";
  version = "0.400002";

  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HA/HAARG/CPAN-Changes-0.400002.tar.gz";
    hash = "sha256-Ae7eqQ0HRoy1jkpQv6O7HU7tqQc1lq3REY/DWRU6vo0=";
  };

  meta = {
    description = "Read and write Changes files";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "tidy_changelog";
  };
}
