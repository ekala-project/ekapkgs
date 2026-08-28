{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "dnsrecon";
  version = "1.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darkoperator";
    repo = "dnsrecon";
    tag = finalAttrs.version;
    hash = "sha256-hDP+zCiZtZaVRYGLTISBjwETkh4LS+E+uBN862VEGdU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=82.0.1" "setuptools"
  '';

  pythonRelaxDeps = true;

  build-system = with python3Packages; [ setuptools ];

  pythonRemoveDeps = [ "slowapi" ];

  dependencies = with python3Packages; [
    dnspython
    loguru
    httpx
    fastapi
    uvicorn
    stamina
    ujson
    lxml
    netaddr
    requests
    setuptools
  ];

  doCheck = false;

  meta = {
    description = "DNS Enumeration script";
    homepage = "https://github.com/darkoperator/dnsrecon";
    license = lib.licenses.gpl2Only;
    mainProgram = "dnsrecon";
  };
})
