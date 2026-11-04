{
  buildPerlPackage,
  fetchurl,
  lib,
  TestException,
  AnyMoose,
}:
buildPerlPackage {
  pname = "MouseX-Types";
  version = "0.06";
  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GF/GFUJI/MouseX-Types-0.06.tar.gz";
    hash = "sha256-dyiEQf2t0Vvu7JoIE+zorsFULx2M6q7BR1Wz8xb7z4s=";
  };
  buildInputs = [ TestException ];
  propagatedBuildInputs = [ AnyMoose ];
  meta = {
    description = "Organize your Mouse types in libraries";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
