{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {
  pname = "Data-Float";
  version = "0.013";
  src = fetchurl {
    url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Data-Float-0.013.tar.gz";
    hash = "sha256-4rFSPYWJMLi729GW8II19eZ4uEkZuodxLiYxO5wnUYo=";
  };
  meta = {
    description = "Details of the floating point data type";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
