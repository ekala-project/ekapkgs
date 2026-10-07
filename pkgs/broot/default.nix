{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  pkg-config,
  libgit2,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "broot";
  version = "1.61.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "broot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RZc2ZCXXvjc+AmLu6TzHNX4UvmL4U/Ds7kP+OfXHfaU=";
  };

  cargoHash = "sha256-Bci3ITSD2PFzZ50Ej6tedGBkopYDcQ4Yj8EuZFhIObo=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    libgit2
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ zlib ];

  buildFeatures = [ "clipboard" ];

  postPatch = ''
    substitute man/page man/broot.1 \
      --replace-fail "#version" "${finalAttrs.version}"
  '';

  postInstall = ''
    installShellCompletion --bash $releaseDir/build/broot-*/out/{br,broot}.bash
    installShellCompletion --fish $releaseDir/build/broot-*/out/{br,broot}.fish
    installShellCompletion --zsh $releaseDir/build/broot-*/out/{_br,_broot}

    installManPage man/broot.1

    wrapProgram $out/bin/broot \
      --set BR_INSTALL no
  '';

  meta = {
    description = "Interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    changelog = "https://github.com/Canop/broot/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    mainProgram = "broot";
  };
})
