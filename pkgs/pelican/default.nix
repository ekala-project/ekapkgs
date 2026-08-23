{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
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

  build-system = [ python3.pkgs.pdm-backend ];

  pythonRelaxDeps = [ "pygments" ];

  dependencies = with python3.pkgs; [
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

  doCheck = false;

  # We only want to patch shebangs in /bin, and not those
  # of the project scripts that are created by Pelican.
  dontPatchShebangs = true;

  postFixup = ''
    patchShebangs $out/bin
  '';

  pythonImportsCheck = [ "pelican" ];

  meta = {
    description = "Static site generator that requires no database or server-side logic";
    homepage = "https://getpelican.com/";
    changelog = "https://github.com/getpelican/pelican/blob/${src.tag}/docs/changelog.rst";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
  };
}
