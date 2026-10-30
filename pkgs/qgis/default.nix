{
  lib,
  stdenv,
  makeWrapper,
  symlinkJoin,
  callPackage,

  extraPythonPackages ? (ps: [ ]),

  # unwrapped package parameters
  withGrass ? false,
  withServer ? false,
}:

let
  qgis-unwrapped = callPackage ./unwrapped.nix {
    inherit withGrass withServer;
  };
in
symlinkJoin {

  inherit (qgis-unwrapped) version outputs;
  pname = "qgis";

  paths = [ qgis-unwrapped ];

  nativeBuildInputs = [
    makeWrapper
    qgis-unwrapped.py.pkgs.wrapPython
  ];

  # Extend to add to the python environment of QGIS without rebuilding QGIS application.
  pythonInputs = qgis-unwrapped.pythonBuildInputs ++ (extraPythonPackages qgis-unwrapped.py.pkgs);

  postBuild = ''
    buildPythonPath "$pythonInputs"

    for program in $out/bin/*; do
      wrapProgram $program \
        --prefix PATH : $program_PATH \
        --set PYTHONHOME ${qgis-unwrapped.py} \
        --set PYTHONPATH $program_PYTHONPATH
    done

    ln -s ${qgis-unwrapped.man} $man
  '';

  passthru = {
    unwrapped = qgis-unwrapped;
    # TODO(ekaos): replace with integrationTests
    # tests.qgis = nixosTests.qgis;
  };

  meta = qgis-unwrapped.meta;
}
