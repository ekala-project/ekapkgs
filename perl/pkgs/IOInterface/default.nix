{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {
  pname = "IO-Interface";
  version = "1.09";

  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LD/LDS/IO-Interface-1.09.tar.gz";
    hash = "sha256-5j6BxS6x4OYOwtmD9VUtJJPhFxeZJclnV/I8S9n6cTo=";
  };

  meta = {
    description = "Access and modify network interface card configuration";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
