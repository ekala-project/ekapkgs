{
  buildPerlPackage,
  fetchurl,
  lib,
  stdenv,
}:
buildPerlPackage {
  pname = "IO-Tty";
  version = "1.20";

  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TO/TODDR/IO-Tty-1.20.tar.gz";
    hash = "sha256-sVMJ/IViOJMonLmyuI36ntHmkVa3XymThVOkW+bXMK8=";
  };

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    homepage = "https://github.com/toddr/IO-Tty";
    description = "Low-level allocate a pseudo-Tty, import constants";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
