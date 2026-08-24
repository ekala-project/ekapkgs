{
  lib,
  fetchFromGitHub,
  python3Packages,
  which,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "glances";
  version = "4.5.6";
  pyproject = true;

  disabled = python3Packages.isPyPy;

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = "glances";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ygXPInfs3jw0Uw3G8DK9llyCpzrtK2/szmKersxCTSI=";
  };

  build-system = with python3Packages; [ setuptools ];

  doCheck = false;

  dependencies =
    with python3Packages;
    [
      defusedxml
      packaging
      psutil
      pyinstrument
      fastapi
      uvicorn
      requests
      jinja2
      python-jose
      prometheus-client
      shtab
    ]
    ++ [ which ];

  meta = {
    homepage = "https://nicolargo.github.io/glances/";
    description = "Cross-platform curses-based monitoring tool";
    mainProgram = "glances";
    license = lib.licenses.lgpl3Only;
    maintainers = [ ];
  };
})
