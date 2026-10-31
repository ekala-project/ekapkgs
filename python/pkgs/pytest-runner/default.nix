{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-runner";
  version = "6.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-runner";
    rev = "v${version}";
    hash = "sha256-FbBVY9At+CmunIiB/qh9DPbpBHNMITYNsVP/FYXnSig=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  doCheck = false;

  meta = {
    description = "Invoke py.test as distutils command with dependency resolution";
    homepage = "https://github.com/pytest-dev/pytest-runner";
    license = lib.licenses.mit;
  };
}
