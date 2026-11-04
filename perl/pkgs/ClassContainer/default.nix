{
  buildPerlModule,
  fetchurl,
  lib,
  ParamsValidate,
}:
buildPerlModule {
  pname = "Class-Container";
  version = "0.13";

  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KW/KWILLIAMS/Class-Container-0.13.tar.gz";
    hash = "sha256-9dSVsd+4JtXAxF0DtNDmtgR8uwbNv2vhX9TckCrutws=";
  };

  propagatedBuildInputs = [ ParamsValidate ];

  meta = {
    description = "Glues object frameworks together transparently";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
