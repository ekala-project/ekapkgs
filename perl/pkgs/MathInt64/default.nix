{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Math-Int64";
  version = "0.54";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SA/SALVA/Math-Int64-0.54.tar.gz";
    hash = "sha256-3PxR5phDfqa5zv4CdiFcVs22p/hePiSitrQYnxlg01E=";
  };
  meta = {
    description = "Manipulate 64 bits integers in Perl";
    homepage = "https://metacpan.org/release/Math-Int64";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
