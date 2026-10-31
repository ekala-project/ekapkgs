{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  systemd,
  pkg-config,
}:

buildPythonPackage rec {
  pname = "systemd-python";
  version = "235";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "python-systemd";
    tag = "v${version}";
    hash = "sha256-8p4m4iM/z4o6PHRQIpuSXb64tPTWGlujEYCDVLiIt2o=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ systemd ];

  # Tests require systemd machine-id
  doCheck = false;

  pythonImportsCheck = [
    "systemd.journal"
    "systemd.id128"
    "systemd.daemon"
    "systemd.login"
  ];

  meta = {
    description = "Python module for native access to the systemd facilities";
    homepage = "https://www.freedesktop.org/software/systemd/python-systemd/";
    license = lib.licenses.lgpl21Plus;
  };
}
