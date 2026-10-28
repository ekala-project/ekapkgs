{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage rec {
  pname = "gunicorn";
  version = "26.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "benoitc";
    repo = "gunicorn";
    tag = version;
    hash = "sha256-duq5ghUuiuZL644jHgZ0qXHkcc8POHt7BX91m9F5BGE=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [ packaging ];

  optional-dependencies = with python3Packages; {
    gevent = [ gevent ];
    eventlet = [ eventlet ];
    tornado = [ tornado ];
    gthread = [ ];
    setproctitle = [ setproctitle ];
  };

  pythonImportsCheck = [ "gunicorn" ];

  nativeCheckInputs =
    with python3Packages;
    [
      pytest-asyncio
      pytestCheckHook
      pytest-cov-stub
    ]
    ++ lib.concatAttrValues optional-dependencies;

  disabledTests = [
    # failure while starting a gunicorn instance
    "TestSignalHandlingIntegration"
  ];

  disabledTestPaths = [
    # tries to start gunicorn and fails on import
    "tests/test_control_socket_integration.py"
  ];

  meta = {
    description = "WSGI HTTP Server for UNIX, fast clients and sleepy applications";
    homepage = "https://github.com/benoitc/gunicorn";
    changelog = "https://github.com/benoitc/gunicorn/releases/tag/${version}";
    license = lib.licenses.mit;
    mainProgram = "gunicorn";
  };
}
