{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "toot";
  version = "0.52.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ihabunek";
    repo = "toot";
    tag = finalAttrs.version;
    hash = "sha256-lsX/34bdnAFWn/MNrQjrPIgkbgFusLvuK54Wc6N8bJU=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    python-dateutil
    requests
    beautifulsoup4
    wcwidth
    urwid
    tomlkit
    click
    pillow
    pysocks
  ];

  meta = {
    description = "Mastodon CLI interface";
    mainProgram = "toot";
    homepage = "https://github.com/ihabunek/toot";
    license = lib.licenses.gpl3Only;
  };
})
