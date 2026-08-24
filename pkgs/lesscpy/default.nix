{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage rec {
  pname = "lesscpy";
  version = "0.15.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T2t/NMIsXOE35+4oDcsZhK3g1QC22rWR1KTYQlLRjek=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    ply
    six
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pythonImportsCheck = [ "lesscpy" ];

  meta = {
    description = "Python LESS Compiler";
    mainProgram = "lesscpy";
    homepage = "https://github.com/lesscpy/lesscpy";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
