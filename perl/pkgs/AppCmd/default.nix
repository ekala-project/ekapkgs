{
  buildPerlPackage,
  fetchurl,
  lib,
  CaptureTiny,
  ClassLoad,
  GetoptLongDescriptive,
  IOTieCombine,
  ModulePluggable,
  StringRewritePrefix,
  TestFatal,
}:
buildPerlPackage {
  pname = "App-Cmd";
  version = "0.336";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/App-Cmd-0.336.tar.gz";
    hash = "sha256-35ZrV9WauxluADBIheW/EXypWBgq4/Tu3xchjqKDjoE=";
  };

  buildInputs = [ TestFatal ];

  propagatedBuildInputs = [
    CaptureTiny
    ClassLoad
    GetoptLongDescriptive
    IOTieCombine
    ModulePluggable
    StringRewritePrefix
  ];

  meta = {
    description = "Write command line apps with less suffering";
    homepage = "https://github.com/rjbs/App-Cmd";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
