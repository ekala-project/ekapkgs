{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "sphinx";
  version = "9.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = "sphinx";
    tag = "v${version}";
    postFetch = ''
      cd "$out";
      mv tests/roots/test-images/{testimäge,testimæge}.png
      sed -i 's/testimäge/testimæge/g' tests/{test_build*.py,roots/test-images/index.rst}
    '';
    hash = "sha256-PgqjCeyHOhWtZjyzSZyvsPT0Q7yRyNDiW3x1fQq0K+8=";
  };

  build-system = [ python3.pkgs.flit-core ];

  dependencies = with python3.pkgs; [
    alabaster
    babel
    docutils
    imagesize
    jinja2
    packaging
    pygments
    requests
    roman-numerals
    snowballstemmer
    sphinxcontrib-applehelp
    sphinxcontrib-devhelp
    sphinxcontrib-htmlhelp
    sphinxcontrib-jsmath
    sphinxcontrib-qthelp
    sphinxcontrib-serializinghtml
    sphinxcontrib-websupport
  ];

  pythonRelaxDeps = [ "docutils" ];

  doCheck = false;

  pythonImportsCheck = [ "sphinx" ];

  meta = {
    description = "Python documentation generator";
    homepage = "https://www.sphinx-doc.org";
    changelog = "https://www.sphinx-doc.org/en/master/changes.html";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
