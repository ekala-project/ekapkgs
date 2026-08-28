{
  lib,
  python3Packages,
  fetchPypi,
  fetchpatch,
}:

python3Packages.buildPythonApplication rec {
  pname = "black";
  version = "25.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M0ltXNEiKtczkTUrSujaFSU8Xeibk6gLPiyNmhnsJmY=";
  };

  patches = [
    (fetchpatch {
      name = "click-8.2-compat-1.patch";
      url = "https://github.com/psf/black/commit/14e1de805a5d66744a08742cad32d1660bf7617a.patch";
      hash = "sha256-fHRlMetE6+09MKkuFNQQr39nIKeNrqwQuBNqfIlP4hc=";
    })
    (fetchpatch {
      name = "click-8.2-compat-2.patch";
      url = "https://github.com/psf/black/commit/ed64d89faa7c738c4ba0006710f7e387174478af.patch";
      hash = "sha256-df/J6wiRqtnHk3mAY3ETiRR2G4hWY1rmZMfm2rjP2ZQ=";
    })
    (fetchpatch {
      name = "click-8.2-compat-3.patch";
      url = "https://github.com/psf/black/commit/b0f36f5b4233ef4cf613daca0adc3896d5424159.patch";
      hash = "sha256-SGLCxbgrWnAi79IjQOb2H8mD/JDbr2SGfnKyzQsJrOA=";
    })
  ];

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
