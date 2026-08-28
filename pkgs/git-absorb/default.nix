{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-absorb";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "tummychow";
    repo = "git-absorb";
    tag = finalAttrs.version;
    hash = "sha256-jAR+Vq6SZZXkseOxZVJSjsQOStIip8ThiaLroaJcIfc=";
  };

  cargoHash = "sha256-8uCXk5bXn/x4QXbGOROGlWYMSqIv+/7dBGZKbYkLfF4=";

  checkFlags = [
    "--skip=tests::and_rebase_flag"
    "--skip=tests::and_rebase_flag_with_rebase_options"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd git-absorb \
      --bash <($out/bin/git-absorb --gen-completions bash) \
      --fish <($out/bin/git-absorb --gen-completions fish) \
      --zsh <($out/bin/git-absorb --gen-completions zsh)
  '';

  meta = {
    homepage = "https://github.com/tummychow/git-absorb";
    description = "git commit --fixup, but automatic";
    license = [ lib.licenses.bsd3 ];
    mainProgram = "git-absorb";
  };
})
