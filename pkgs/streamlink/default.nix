{
  lib,
  python3Packages,
  fetchPypi,
  extras ? [ ],
}:

python3Packages.buildPythonApplication rec {
  pname = "streamlink";
  version = "8.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gIJwNzTfe+BzfE2b4d6/VyquZmnP5cWJFEGnoWNv8yA=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    mock
    requests-mock
    freezegun
    pytest-trio
    pytest-cov-stub
  ];

  disabledTests = [
    # requires ffmpeg to be in PATH
    "test_no_cache"
  ];

  propagatedBuildInputs =
    with python3Packages;
    [
      certifi
      isodate
      lxml
      pycountry
      pycryptodome
      pysocks
      requests
      trio
      trio-websocket
      urllib3
      websocket-client
    ]
    ++ lib.flatten (lib.attrVals extras optional-dependencies);

  optional-dependencies = with python3Packages; {
    decompress = urllib3.optional-dependencies.brotli ++ urllib3.optional-dependencies.zstd;
  };

  meta = {
    changelog = "https://streamlink.github.io/changelog.html";
    description = "CLI for extracting streams from various websites to video player of your choosing";
    homepage = "https://streamlink.github.io/";
    license = lib.licenses.bsd2;
    mainProgram = "streamlink";
    maintainers = [ ];
  };
}
