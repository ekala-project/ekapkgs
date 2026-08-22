{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  pandoc ? null,
}:

python3Packages.buildPythonApplication rec {
  pname = "httpie";
  version = "3.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "httpie";
    repo = "cli";
    tag = version;
    hash = "sha256-uZKkUUrPPnLHPHL8YrZgfsyCsSOR0oZ2eFytiV0PIUY=";
  };

  pythonRelaxDeps = [
    "defusedxml"
    "requests"
    "pip"
  ];

  pythonRemoveDeps = [
    "pip"
  ];

  build-system = with python3Packages; [ setuptools ];

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals (pandoc != null) [ pandoc ];

  dependencies =
    with python3Packages;
    [
      charset-normalizer
      defusedxml
      multidict
      pygments
      requests
      requests-toolbelt
      setuptools
      rich
    ]
    ++ requests.optional-dependencies.socks;

  postInstall = ''
    installShellCompletion --cmd http \
      --bash extras/httpie-completion.bash \
      --fish extras/httpie-completion.fish
  ''
  + lib.optionalString (pandoc != null) ''
    pandoc --standalone -f markdown -t man docs/README.md -o docs/http.1
    installManPage docs/http.1
  '';

  doCheck = false;

  pythonImportsCheck = [ "httpie" ];

  meta = {
    description = "Command line HTTP client whose goal is to make CLI human-friendly";
    homepage = "https://httpie.org/";
    changelog = "https://github.com/httpie/cli/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "http";
  };
}
