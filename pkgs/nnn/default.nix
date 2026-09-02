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
  version = "5.3";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "nnn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l6/q3eFX/M4hvxOuKm31Xh+UBV+McvH09Sa7yK2/+W4=";
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
    mainProgram = "nnn";
  };
})
