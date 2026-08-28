{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "b4";
  version = "0.16.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-BxgjoekEUIpv2ar4zC+akml+HfonAAC00RMAFbVvQTc=";
  };

  doCheck = false;

  pythonRemoveDeps = [
    "patatt"
    "git-filter-repo"
    "ezgb"
    "liblore"
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    requests
    dnspython
    dkimpy
    pygit2
    textual
  ];

  meta = {
    homepage = "https://git.kernel.org/pub/scm/utils/b4/b4.git/about";
    license = lib.licenses.gpl2Only;
    description = "Helper utility to work with patches made available via a public-inbox archive";
    mainProgram = "b4";
  };
})
