{
  buildPerlModule,
  fetchurl,
  lib,
  Test2Suite,
}:
buildPerlModule {
  pname = "Struct-Dumb";
  version = "0.14";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PEVANS/Struct-Dumb-0.14.tar.gz";
    hash = "sha256-E8FIU2sQ4oxuC04TLynkym5ptXSQWcRBV6J+hKVFlDY=";
  };

  buildInputs = [ Test2Suite ];

  meta = {
    description = "Make simple lightweight record-like structures";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
