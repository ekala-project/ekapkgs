{
  buildPerlPackage,
  fetchurl,
  lib,
  MathBigIntGMP,
}:
buildPerlPackage {
  pname = "Crypt-DH";
  version = "0.07";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MITHALDU/Crypt-DH-0.07.tar.gz";
    hash = "sha256-yIzzQjsB5nguiYbX/lMEQ2q4SwklxEmMb9+hfvmjf18=";
  };
  propagatedBuildInputs = [ MathBigIntGMP ];
  meta = {
    description = "Diffie-Hellman key exchange system";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
