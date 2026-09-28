{
  lib,
  stdenv,
  libdiscid,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "discid";
  version = "1.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DLtLlpScaMvGPJ/EWF75t+wrnTniO84LTbXWHG97geY=";
  };

  build-system = [ setuptools ];

  patchPhase =
    let
      extension = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      substituteInPlace discid/libdiscid.py \
        --replace "_open_library(_LIB_NAME)" \
                  "_open_library('${libdiscid}/lib/libdiscid${extension}')"
    '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python binding of libdiscid";
    homepage = "https://python-discid.readthedocs.org/";
    license = lib.licenses.lgpl3Plus;
  };
}
