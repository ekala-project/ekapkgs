{
  lib,
  fetchFromGitHub,
  python3Packages,
  which,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "glances";
  version = "4.5.7";
  pyproject = true;

  disabled = python3Packages.isPyPy;

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = "glances";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4SaIrvudjK2NGe13PscO3+5EYr2zgzb1mhRvTlEAZyg=";
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
  };
})
