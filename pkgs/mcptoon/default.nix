{
  lib,
  python3,
  fetchFromGitHub,
  gitMinimal,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mcptoon";
  version = "0.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "activeing123";
    repo = "mcptoon";
    tag = "v${version}";
    hash = "sha256-O9F29hY8QSy9FbIC8RQ/U7tFTRScnwkSLpbixg62RCU=";
  };

  # Upstream tags releases without bumping __version__; align it with the tag.
  postPatch = ''
    sed -i -E 's/^__version__ = ".*"/__version__ = "${version}"/' src/mcptoon/__init__.py
  '';

  build-system = with python3.pkgs; [ setuptools ];

  pythonImportsCheck = [ "mcptoon" ];

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
    # test_skills.py tombstone tests commit into a scratch repo
    gitMinimal
  ];

  # config.py creates ~/.config/mcptoon at import time; tests need a writable HOME.
  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = {
    description = "MCP server that turns OpenAPI specs into agent-friendly tools";
    homepage = "https://github.com/activeing123/mcptoon";
    changelog = "https://github.com/activeing123/mcptoon/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "mcptoon";
  };
}
