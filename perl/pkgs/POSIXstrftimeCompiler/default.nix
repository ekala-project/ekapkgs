{
  buildPerlModule,
  fetchurl,
  lib,
  ModuleBuildTiny,
}:
buildPerlModule {
  pname = "POSIX-strftime-Compiler";
  version = "0.44";

  nativeBuildInputs = [ ModuleBuildTiny ];

  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KA/KAZEBURO/POSIX-strftime-Compiler-0.44.tar.gz";
    hash = "sha256-39PJc5jc/lHII2uF49woA1Znt2Ux96oKZTXzqlQFs1o=";
  };

  meta = {
    description = "GNU C library compatible strftime for loggers and servers";
    homepage = "https://github.com/kazeburo/POSIX-strftime-Compiler";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
