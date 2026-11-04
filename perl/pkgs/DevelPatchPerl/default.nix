{
  buildPerlPackage,
  fetchurl,
  lib,
  Filepushd,
  ModulePluggable,
}:
buildPerlPackage {
  pname = "Devel-PatchPerl";
  version = "2.08";

  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BI/BINGOS/Devel-PatchPerl-2.08.tar.gz";
    hash = "sha256-acbpcBYmD0COnX5Ej5QrNqbUnfWvBzQPHWXX4jAWdBk=";
  };

  propagatedBuildInputs = [
    Filepushd
    ModulePluggable
  ];

  meta = {
    description = "Patch perl source a la Devel::PPPort's buildperl.pl";
    homepage = "https://github.com/bingos/devel-patchperl";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "patchperl";
  };
}
