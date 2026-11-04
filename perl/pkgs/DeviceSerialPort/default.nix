{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Device-SerialPort";
  version = "1.04";

  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CO/COOK/Device-SerialPort-1.04.tar.gz";
    hash = "sha256-05JWfLObTqYGwOCsr9jtcjIDEbmVM27OX878+bFQ6dc=";
  };

  meta = {
    description = "Linux/POSIX emulation of Win32::SerialPort functions";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "modemtest";
  };
}
