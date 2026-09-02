{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hwatch";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "blacknon";
    repo = "hwatch";
    tag = finalAttrs.version;
    hash = "sha256-ic83D46CGDWRqcNJt/KcMEsnKj6rO/LsTNm247YK/Qs=";
  };

  cargoHash = "sha256-xJZpZPhjU81cb00O/FE0QGOsRKY9BG4oGMk2jNy2skw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd hwatch --"$shell" <("$out/bin/hwatch" --completion "$shell")
    done
  '';

  meta = {
    description = "Modern alternative to the watch command";
    homepage = "https://github.com/blacknon/hwatch";
    changelog = "https://github.com/blacknon/hwatch/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "hwatch";
  };
})
