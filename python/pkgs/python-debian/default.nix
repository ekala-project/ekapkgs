{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
  charset-normalizer,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-debian";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "python-debian-team";
    repo = "python-debian";
    tag = finalAttrs.version;
    hash = "sha256-K5i0zDZXeAgoAdblqp+f5QX9FIZYVpJ4wWk29hwVjfM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  optional-dependencies.encodings = [
    charset-normalizer
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "debian" ];

  meta = {
    description = "Debian package related modules";
    homepage = "https://salsa.debian.org/python-debian-team/python-debian";
    license = lib.licenses.gpl2Plus;
  };
})
