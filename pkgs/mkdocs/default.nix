{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
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

  build-system =
    with python3.pkgs;
    [
      hatchling
      babel
    ]
    ++ lib.optionals (lib.versionAtLeast python3.version "3.12") [
      python3.pkgs.setuptools
    ];

  dependencies = with python3.pkgs; [
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
    changelog = "https://github.com/mkdocs/mkdocs/releases/tag/${version}";
    description = "Project documentation with Markdown / static website generator";
    mainProgram = "mkdocs";
    homepage = "http://mkdocs.org/";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
