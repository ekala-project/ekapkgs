{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  file,
  replaceVars,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-magic";
  version = "0.4.27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ahupp";
    repo = "python-magic";
    tag = finalAttrs.version;
    hash = "sha256-fZ+5xJ3P0EYK+6rQ8VzXv2zckKfEH5VUdISIR6ybIfQ=";
  };

  patches = [
    (replaceVars ./libmagic-path.patch {
      libmagic = "${file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  build-system = [ setuptools ];

  # Tests require additional patches

  pythonImportsCheck = [ "magic" ];

  meta = {
    description = "Python interface to the libmagic file type identification library";
    homepage = "https://github.com/ahupp/python-magic";
    license = lib.licenses.mit;
  };
})
