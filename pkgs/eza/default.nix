{
  lib,
  gitSupport ? true,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  pkg-config,
  zlib,
  installShellFiles,
  exaAlias ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "eza";
  version = "0.23.5";

  src = fetchFromGitHub {
    owner = "eza-community";
    repo = "eza";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4XgPePl90mnQxmTUJfOvIsCcTRSYNBuRUNOb/3kmO1k=";
  };

  cargoHash = "sha256-IRG+mVgU8ZZ8PsxZWqmf3ZjW8fGL0RD0CwIrjsL366I=";

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ];
  buildInputs = [ zlib ];

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional gitSupport "git";

  postInstall = ''
    installShellCompletion \
      --bash completions/bash/eza \
      --fish completions/fish/eza.fish \
      --zsh completions/zsh/_eza
  ''
  + lib.optionalString exaAlias ''
    ln -s eza $out/bin/exa
  '';

  meta = {
    description = "Modern, maintained replacement for ls";
    longDescription = ''
      eza is a modern replacement for ls. It uses colours for information by
      default, helping you distinguish between many types of files, such as
      whether you are the owner, or in the owning group. It also has extra
      features not present in the original ls, such as viewing the Git status
      for a directory, or recursing into directories with a tree view. eza is
      written in Rust, so it's small, fast, and portable.
    '';
    homepage = "https://github.com/eza-community/eza";
    changelog = "https://github.com/eza-community/eza/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.eupl12;
    mainProgram = "eza";
  };
})
