{
  buildPerlModule,
  fetchurl,
  lib,
  ClassXSAccessor,
  FileFindObject,
  NumberCompare,
  TextGlob,
  FileTreeCreate,
}:
buildPerlModule {
  pname = "File-Find-Object-Rule";
  version = "0.0313";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/File-Find-Object-Rule-0.0313.tar.gz";
    hash = "sha256-gZQPKZ1khySPvzDY8ft99sajSz35RApWIbE1yONPz/I=";
  };

  buildInputs = [ FileTreeCreate ];

  propagatedBuildInputs = [
    ClassXSAccessor
    FileFindObject
    NumberCompare
    TextGlob
  ];

  # restore t/sample-data which is corrupted by patching shebangs
  preCheck = ''
    tar xf $src */t/sample-data --strip-components=1
  '';

  meta = {
    description = "Alternative interface to File::Find::Object";
    homepage = "https://www.shlomifish.org/open-source/projects/File-Find-Object";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "findorule";
  };
}
