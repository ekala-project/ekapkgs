{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  net-tools,
}:

python3Packages.buildPythonApplication {
  pname = "magic-wormhole";
  version = "0.24.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "magic-wormhole";
    repo = "magic-wormhole";
    tag = "0.24.0";
    hash = "sha256-aY8dI5K2qroY+Nbc00R5XK0AjHpdnXFYWABgPqf8gQ8=";
  };

  postPatch = ''
    substituteInPlace src/wormhole/test/test_cli.py --replace-fail \
      'locations = procutils.which("wormhole")' \
      'return "$out/bin/wormhole"'

    sed -i -e "s|'ifconfig'|'${net-tools}/bin/ifconfig'|" src/wormhole/ipaddrs.py
  '';

  build-system = with python3Packages; [
    setuptools
    versioneer
  ];

  dependencies =
    with python3Packages;
    [
      attrs
      autobahn
      automat
      click
      cryptography
      humanize
      iterable-io
      pynacl
      qrcode
      spake2
      tqdm
      twisted
      txtorcon
      zipstream-ng
    ]
    ++ autobahn.optional-dependencies.twisted
    ++ twisted.optional-dependencies.tls;

  optional-dependencies = with python3Packages; {
    dilation = [ noiseprotocol ];
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  # Tests require a running mailbox server
  doCheck = false;

  postInstall = ''
    install -Dm644 docs/wormhole.1 $out/share/man/man1/wormhole.1

    # https://github.com/magic-wormhole/magic-wormhole/issues/619
    installShellCompletion --cmd wormhole \
      --bash wormhole_complete.bash \
      --fish wormhole_complete.fish \
      --zsh wormhole_complete.zsh
    rm $out/wormhole_complete.*
  '';

  pythonImportsCheck = [ "wormhole" ];

  meta = {
    changelog = "https://github.com/magic-wormhole/magic-wormhole/blob/0.24.0/NEWS.md";
    description = "Securely transfer data between computers";
    homepage = "https://magic-wormhole.readthedocs.io/";
    license = lib.licenses.mit;
    mainProgram = "wormhole";
  };
}
