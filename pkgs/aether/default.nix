{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  autoPatchelfHook,
  webkitgtk,
  gtk3,
}:

let
  version = "4.31.1";

  binary = fetchurl {
    url = "https://github.com/omacom/aether/releases/download/v${version}/aether-linux-${
      if stdenv.hostPlatform.isx86_64 then "amd64" else "arm64"
    }";
    hash =
      if stdenv.hostPlatform.isx86_64 then
        "sha256-Ksd1oz1j1g5Ghs9KsVFe3TIEHT68zKBh9zYlXkrhOHo="
      else
        "sha256-10MT20umLaUMNyKP8u4tKxOROZ5zrE9LRzpTJu3Yi34=";
  };
in
stdenv.mkDerivation {
  pname = "aether";
  inherit version;

  src = fetchFromGitHub {
    owner = "omacom";
    repo = "aether";
    tag = "v${version}";
    hash = "sha256-ZOFHeAUJrohcTtqaBNXnuqA19Cx+i6+k6clM+Cpx9X0=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    webkitgtk
    gtk3
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 ${binary} "$out/bin/aether"
    install -Dm644 build/linux/aether.desktop "$out/share/applications/aether.desktop"
    install -Dm644 li.oever.aether.url-handler.desktop "$out/share/applications/li.oever.aether.url-handler.desktop"
    install -Dm644 icon.png "$out/share/pixmaps/aether.png"
    install -Dm644 assets/aether-icon-512.png "$out/share/icons/hicolor/512x512/apps/aether.png"
    runHook postInstall
  '';

  meta = {
    description = "Desktop theming — extract colors from wallpapers and apply cohesive themes";
    homepage = "https://github.com/omacom/aether";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "aether";
  };
}
