{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {
  pname = "Data-Serializer";
  version = "0.65";

  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEELY/Data-Serializer-0.65.tar.gz";
    hash = "sha256-EhVaUgADPYCl8HVzd19JPxcAcs97KK48otFStZGXHxE=";
  };

  meta = {
    description = "Modules that serialize data structures";
    homepage = "https://metacpan.org/release/Data-Serializer";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
