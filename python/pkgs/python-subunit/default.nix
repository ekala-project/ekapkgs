{
  lib,
  buildPythonPackage,
  pkgs,
  pkg-config,
  setuptools,
  iso8601,
  pyyaml,
  testtools,
}:

buildPythonPackage {
  pname = "python-subunit";
  inherit (pkgs.subunit) version src meta;
  pyproject = true;

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version=VERSION" 'version="${pkgs.subunit.version}"'
  '';

  nativeBuildInputs = [
    pkg-config
    setuptools
  ];

  buildInputs = [
    pkgs.check
    pkgs.cppunit
  ];

  propagatedBuildInputs = [
    iso8601
    pyyaml
    testtools
  ];

  # tests require testscenarios, hypothesis, etc. and are fragile

  pythonImportsCheck = [ "subunit" ];
}
