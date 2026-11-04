{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  db,
}:

buildPythonPackage rec {
  pname = "bsddb3";
  version = "6.2.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cNBeyNxWj0LnD8kZpELg2q3CqQWhz7fKd/VJ1J1ueAE=";
  };

  build-system = [ setuptools ];

  buildInputs = [ db ];

  env.BERKELEYDB_DIR = db.dev;

  pythonImportsCheck = [ "bsddb3" ];

  meta = {
    description = "Python bindings for Oracle Berkeley DB";
    homepage = "https://www.jcea.es/programacion/pybsddb.htm";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
