{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  pkg-config,
  file,
  ncurses,
  readline,
  which,
  gnused,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nnn";
  version = "5.2";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "nnn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u+88aDHfOZ6bSkg6ahS6eNZWj2QCwJXKW+8nHR99kic=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    readline
    ncurses
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  binPath = lib.makeBinPath [
    file
    which
    gnused
  ];

  installTargets = [
    "install"
    "install-desktop"
  ];

  postInstall = ''
    installShellCompletion --bash --name nnn.bash misc/auto-completion/bash/nnn-completion.bash
    installShellCompletion --fish misc/auto-completion/fish/nnn.fish
    installShellCompletion --zsh misc/auto-completion/zsh/_nnn

    cp -r plugins $out/share
    cp -r misc/quitcd $out/share/quitcd

    wrapProgram $out/bin/nnn --prefix PATH : "$binPath"
  '';

  meta = {
    description = "Small ncurses-based file browser forked from noice";
    homepage = "https://github.com/jarun/nnn";
    changelog = "https://github.com/jarun/nnn/blob/v${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    mainProgram = "nnn";
  };
})
