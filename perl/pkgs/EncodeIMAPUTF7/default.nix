{
  buildPerlPackage,
  fetchurl,
  lib,
  TestNoWarnings,
}:
buildPerlPackage {
  pname = "Encode-IMAPUTF7";
  version = "1.05";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMAKHOLM/Encode-IMAPUTF7-1.05.tar.gz";
    hash = "sha256-RwMF3cN0g8/o08FtE3cKKAEfYAv1V6y4w+B3OZl8N+E=";
  };
  patches = [ ./encode-imaputf7.patch ];
  nativeCheckInputs = [ TestNoWarnings ];
  meta = {
    description = "IMAP modified UTF-7 encoding";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
