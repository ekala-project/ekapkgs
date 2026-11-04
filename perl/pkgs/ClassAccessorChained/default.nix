{
  buildPerlModule,
  fetchurl,
  lib,
  ClassAccessor,
}:
buildPerlModule {
  pname = "Class-Accessor-Chained";
  version = "0.01";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RC/RCLAMP/Class-Accessor-Chained-0.01.tar.gz";
    hash = "sha256-pb9J04BPg60lobFvMn0U1MvuInATIQSyhwUDHbzMNNI=";
  };

  propagatedBuildInputs = [ ClassAccessor ];

  meta = {
    description = "Make chained accessors";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
