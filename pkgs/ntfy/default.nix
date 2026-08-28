{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  writableTmpDirAsHomeHook ? null,
  withEmoji ? true,
  withPid ? true,
  withDbus ? stdenv.hostPlatform.isLinux,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ntfy";
  version = "2.7.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "dschep";
    repo = "ntfy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EIhoZ2tFJQOc5PyRCazwRhldFxQb65y6h+vYPwV7ReE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "':sys_platform == \"darwin\"'" "'darwin'"
  '';

  build-system = with python3Packages; [ setuptools ];

  dependencies =
    with python3Packages;
    [
      requests
      ruamel-yaml
      appdirs
    ]
    ++ lib.optionals withEmoji [
      emoji
    ]
    ++ lib.optionals withPid [
      psutil
    ]
    ++ lib.optionals withDbus [
      dbus-python
    ];

  nativeCheckInputs =
    with python3Packages;
    [
      mock
      pytestCheckHook
    ]
    ++ lib.optionals (writableTmpDirAsHomeHook != null) [
      writableTmpDirAsHomeHook
    ];

  disabledTests = [
    "test_default_config"
    "test_xmpp"
  ];

  disabledTestPaths = [
    "tests/test_xmpp.py"
  ];

  pythonImportsCheck = [ "ntfy" ];

  meta = {
    description = "Utility for sending notifications, on demand and when commands finish";
    homepage = "https://ntfy.readthedocs.io/en/latest/";
    license = lib.licenses.gpl3Only;
    mainProgram = "ntfy";
  };
})
