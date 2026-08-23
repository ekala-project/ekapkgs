{
  lib,
  python3,
  fetchFromGitHub,
  installShellFiles,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "asciidoc";
  version = "10.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asciidoc-py";
    repo = "asciidoc-py";
    tag = version;
    hash = "sha256-hsnQKQsWu2YaQFpCUVaOhZ/rxCCjtNXFEXasRF0SFRE=";
  };

  build-system = [ python3.pkgs.setuptools ];
  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage doc/asciidoc.1
    installManPage doc/a2x.1
  '';

  meta = {
    description = "Text-based document generation system";
    homepage = "https://asciidoc-py.github.io/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "asciidoc";
  };
}
