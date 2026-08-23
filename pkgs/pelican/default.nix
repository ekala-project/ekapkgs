{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "pelican";
  version = "4.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getpelican";
    repo = "pelican";
    tag = version;
    hash = "sha256-g/wm4ZA4KBMnvpe58ZQ7lTUBF6PywC4IivmBBco4F00=";
    postFetch = ''
      rm -r $out/pelican/tests/output/custom_locale/posts
    '';
  };

  build-system = with python3Packages; [ pdm-backend ];

  pythonRelaxDeps = [ "pygments" ];

  dependencies = with python3Packages; [
    blinker
    docutils
    feedgenerator
    jinja2
    ordered-set
    pygments
    python-dateutil
    rich
    tzdata
    unidecode
    watchfiles
  ];

  # Tests require complex setup
  doCheck = false;

  dontPatchShebangs = true;

  postFixup = ''
    patchShebangs $out/bin
  '';

  pythonImportsCheck = [ "pelican" ];

  meta = {
    description = "Static site generator that requires no database or server-side logic";
    homepage = "https://getpelican.com/";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
  };
}
