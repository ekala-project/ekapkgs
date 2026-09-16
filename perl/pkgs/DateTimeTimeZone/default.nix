{
  buildPerlPackage,
  fetchurl,
  lib,
  TestFatal,
  TestRequires,
  ClassSingleton,
  ParamsValidationCompiler,
  Specio,
  namespaceautoclean,
}:
buildPerlPackage {
  pname = "DateTime-TimeZone";
  version = "2.60";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-TimeZone-2.60.tar.gz";
    hash = "sha256-8EYNN5MjkFtXm+1E4UEjejN9wl3Sa2qwxgrCuAYpMj0=";
  };
  buildInputs = [
    TestFatal
    TestRequires
  ];
  propagatedBuildInputs = [
    ClassSingleton
    ParamsValidationCompiler
    Specio
    namespaceautoclean
  ];
  meta = {
    description = "Time zone object base class and factory";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
