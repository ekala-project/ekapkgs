{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Tie-ToObject";
  version = "0.03";

  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NU/NUFFIN/Tie-ToObject-0.03.tar.gz";
    hash = "sha256-oxoNRDD+FPWWIvMdt/JbInXa0uxS8QQL6wMNPoOtOvQ=";
  };

  meta = {
    description = "Tie to an existing object";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
