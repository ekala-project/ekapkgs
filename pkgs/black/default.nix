{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "black";
  version = "26.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s0ds5xtJT8bjnXfnVIjoM5qHWDApu/YIQW6VXINYK9Y=";
  };

  patches = [
  ];

  # pytokens is not yet packaged
  pythonRemoveDeps = [ "pytokens" ];

  build-system = with python3Packages; [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  dependencies = with python3Packages; [
    click
    mypy-extensions
    packaging
    pathspec
    platformdirs
  ];

  optional-dependencies = with python3Packages; {
    colorama = [ colorama ];
    d = [ aiohttp ];
    uvloop = [ uvloop ];
    jupyter = [
      ipython
      tokenize-rt
    ];
  };

  doCheck = false;

  meta = {
    description = "Uncompromising Python code formatter";
    homepage = "https://github.com/psf/black";
    changelog = "https://github.com/psf/black/blob/${version}/CHANGES.md";
    license = lib.licenses.mit;
    mainProgram = "black";
  };
}
