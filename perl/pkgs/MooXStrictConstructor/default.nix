{
  buildPerlPackage,
  fetchurl,
  lib,
  Moo,
  strictures,
  TestFatal,
}:
buildPerlPackage {
  pname = "MooX-StrictConstructor";
  version = "0.011";

  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HA/HARTZELL/MooX-StrictConstructor-0.011.tar.gz";
    hash = "sha256-2jgvgi/8TiKgOqQZpCVydJmdNtiaThI27PT892vGU+I=";
  };

  propagatedBuildInputs = [
    Moo
    strictures
  ];

  buildInputs = [ TestFatal ];

  meta = {
    description = "Make your Moo-based object constructors blow up on unknown attributes";
    homepage = "https://metacpan.org/release/MooX-StrictConstructor";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
