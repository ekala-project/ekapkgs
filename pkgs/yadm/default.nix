{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  bash,
  makeWrapper,
  installShellFiles,
  gnupg ? null,
  openssl ? null,
  gawk ? null,
  gnutar ? null,
  coreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yadm";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "yadm-dev";
    repo = "yadm";
    rev = finalAttrs.version;
    hash = "sha256-hDo6zs70apNhKmuvR+eD51FzuTLj3SL/wHQXqLMD9QE=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin yadm
    runHook postInstall
  '';

  postInstall = ''
    installManPage yadm.1
    installShellCompletion --cmd yadm \
      --zsh completion/zsh/_yadm \
      --bash completion/bash/yadm
  '';

  postFixup = ''
    wrapProgram $out/bin/yadm \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            git
            bash
            coreutils
          ]
          ++ lib.optional (gnupg != null) gnupg
          ++ lib.optional (openssl != null) openssl
          ++ lib.optional (gawk != null) gawk
          ++ lib.optional (gnutar != null) gnutar
        )
      }
  '';

  meta = {
    homepage = "https://github.com/yadm-dev/yadm";
    description = "Yet Another Dotfiles Manager";
    longDescription = ''
      yadm is a dotfile management tool with 3 main features:
      * Manages files across systems using a single Git repository.
      * Provides a way to use alternate files on a specific OS or host.
      * Supplies a method of encrypting confidential data so it can safely be stored in your repository.
    '';
    changelog = "https://github.com/yadm-dev/yadm/blob/${finalAttrs.version}/CHANGES";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "yadm";
  };
})
