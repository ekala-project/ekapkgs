{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyqt5,
  qtpy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "qtawesome";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spyder-ide";
    repo = "qtawesome";
    tag = "v${version}";
    hash = "sha256-CdELoMML7j9m1HrAY8MhKcYx5Q4xuEMZIBeyzQnRQtk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyqt5
    qtpy
  ];

  # Requires qtbot which is unmaintained

  pythonImportsCheck = [ "qtawesome" ];

  meta = {
    description = "Iconic fonts in PyQt and PySide applications";
    mainProgram = "qta-browser";
    homepage = "https://github.com/spyder-ide/qtawesome";
    changelog = "https://github.com/spyder-ide/qtawesome/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
