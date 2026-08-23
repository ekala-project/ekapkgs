{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "mkdocs";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkdocs";
    repo = "mkdocs";
    tag = version;
    hash = "sha256-JQSOgV12iYE6FubxdoJpWy9EHKFxyKoxrm/7arCn9Ak=";
  };

  patches = [
    ./click-8.3.0-compat.patch
  ];

  build-system = with python3Packages; [
    hatchling
    babel
    setuptools
  ];

  dependencies = with python3Packages; [
    click
    ghp-import
    jinja2
    markdown
    markupsafe
    mergedeep
    mkdocs-get-deps
    packaging
    pathspec
    platformdirs
    pyyaml
    pyyaml-env-tag
    watchdog
  ];

  doCheck = false;

  pythonImportsCheck = [ "mkdocs" ];

  meta = {
    description = "Project documentation with Markdown / static website generator";
    mainProgram = "mkdocs";
    homepage = "http://mkdocs.org/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
