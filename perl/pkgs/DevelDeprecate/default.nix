{
  buildPerlPackage,
  fetchurl,
  lib,
  SubOverride,
  DateTime,
}:
buildPerlPackage {
  pname = "Devel-Deprecate";
  version = "0.01";

  src = fetchurl {
    url = "mirror://cpan/authors/id/O/OV/OVID/Devel-Deprecate-0.01.tar.gz";
    hash = "sha256-xQLEGoL+JU6XFRJ3ytOk8KQHrTydP2I9J3sDA6PhoS8=";
  };

  buildInputs = [ SubOverride ];

  propagatedBuildInputs = [ DateTime ];

  meta = {
    description = "Create deprecation schedules in your code";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
