{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  click,
  click-log,
  requests,
  aiostream,
  aiohttp,
}:

buildPythonPackage (finalAttrs: {
  pname = "vdirsyncer";
  version = "0.20.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-/rGlM1AKlcFP0VVzOhBW/jWRklU9gsB8a6BPy/xAsS0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    click
    click-log
    requests
    aiostream
    aiohttp
  ];

  # Tests require hypothesis, pytest-asyncio, trustme, aioresponses
  doCheck = false;

  meta = {
    description = "Synchronize calendars and contacts";
    homepage = "https://github.com/pimutils/vdirsyncer";
    license = lib.licenses.bsd3;
    mainProgram = "vdirsyncer";
    broken = true; # aiohttp dependency fails: backports-zstd doesn't support Python 3.14
  };
})
