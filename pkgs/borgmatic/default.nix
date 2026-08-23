{
  borgbackup,
  coreutils,
  enableSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  fetchPypi,
  installShellFiles,
  lib,
  python3Packages,
  stdenv,
  systemd,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "borgmatic";
  version = "2.1.7";
  pyproject = true;

  strictDeps = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-qsB8564wCWBemsxn7vIBmntdabzK1j7agP8ZK2nzdc8=";
  };

  nativeCheckInputs =
    with python3Packages;
    [
      flexmock
      pytestCheckHook
      pytest-asyncio
      pytest-cov-stub
      pytest-timeout
    ]
    ++ finalAttrs.passthru.optional-dependencies.apprise
    ++ finalAttrs.passthru.optional-dependencies.browse;

  disabledTests = [
    "test_borgmatic_version_matches_news_version"
    "test_log_outputs_includes_error_output_in_exception"
  ];

  nativeBuildInputs = [ installShellFiles ];

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    borgbackup
    colorama
    jsonschema
    packaging
    requests
    ruamel-yaml
  ];

  optional-dependencies = {
    apprise = [ python3Packages.apprise ];
    browse = with python3Packages; [
      binaryornot
      textual
    ];
  };

  postInstall =
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd borgmatic \
        --bash <($out/bin/borgmatic --bash-completion) \
        --fish <($out/bin/borgmatic --fish-completion)
    ''
    + lib.optionalString enableSystemd ''
      mkdir -p $out/lib/systemd/system
      cp sample/systemd/borgmatic.timer $out/lib/systemd/system/
      substitute sample/systemd/borgmatic.service \
        $out/lib/systemd/system/borgmatic.service \
        --replace-fail /root/.local/bin/borgmatic $out/bin/borgmatic \
        --replace-fail systemd-inhibit ${systemd}/bin/systemd-inhibit \
        --replace-fail "sleep " "${coreutils}/bin/sleep "
    '';

  meta = {
    description = "Simple, configuration-driven backup software for servers and workstations";
    homepage = "https://torsion.org/borgmatic/";
    changelog = "https://projects.torsion.org/borgmatic-collective/borgmatic/src/tag/${finalAttrs.version}/NEWS";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    mainProgram = "borgmatic";
    maintainers = [ ];
  };
})
