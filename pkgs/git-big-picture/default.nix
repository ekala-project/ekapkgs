{
  lib,
  python3Packages,
  fetchFromGitHub,
  git,
  graphviz,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "git-big-picture";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "git-big-picture";
    repo = "git-big-picture";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dz1lgDFIukX36pQWdCYck21OekQkV9sJ6ff7u3fDkPM=";
  };

  build-system = with python3Packages; [ setuptools ];

  postFixup = ''
    wrapProgram $out/bin/git-big-picture \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          graphviz
        ]
      }
  '';

  meta = {
    description = "Tool for visualization of Git repositories";
    homepage = "https://github.com/git-big-picture/git-big-picture";
    license = lib.licenses.gpl3Plus;
    mainProgram = "git-big-picture";
  };
})
