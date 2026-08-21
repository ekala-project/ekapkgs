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
  version = "1.57.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "broot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uRMa8zaXXM8KWUplYMyOLic/WITLU0eAbZ2VDgM/PBw=";
  };

  cargoHash = "sha256-p4R8+PcRmjy/2q7lpfUevuYROPrCQEffmXx5vRrjwKs=";

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
    maintainers = [ ];
    license = with lib.licenses; [ mit ];
    mainProgram = "broot";
  };
})
