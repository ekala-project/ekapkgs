{
  lib,
  python3,
  fetchPypi,
  mailman,
}:

with python3.pkgs;

buildPythonPackage (finalAttrs: {
  pname = "mailman-hyperkitty";
  version = "1.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-+Nad+8bMtYKJbUCpppRXqhB1zdbvvFXTTHlwJLQLzDg=";
  };

  propagatedBuildInputs = [
    mailman
    requests
    zope-interface
  ];

  nativeCheckInputs = [
    mock
    nose2
  ];

  checkPhase = ''
    ${python.interpreter} -m nose2 -v
  '';

  pythonImportsCheck = [
    "mailman_hyperkitty"
  ];

  passthru = {
    # TODO(ekaos): replace with integrationTests
    # tests = { inherit (nixosTests) mailman; };
  };

  meta = {
    description = "Mailman archiver plugin for HyperKitty";
    homepage = "https://gitlab.com/mailman/mailman-hyperkitty";
    license = lib.licenses.gpl3Plus;
  };
})
