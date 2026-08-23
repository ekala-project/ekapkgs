{
  lib,
  rustPlatform,
  fetchFromGitHub,
  withCmd ? false,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kanata";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = "kanata";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WjdmjgEMoo3QNqT4yWxaKOkfuRLdNg4Im+V1Hy5vWgY=";
  };

  cargoHash = "sha256-4UBN4I35ZPPPL68LxxPna9Fs9sATCiwoTbWgHYwqOjs=";

  buildFeatures = lib.optional withCmd "cmd";

  postInstall = ''
    install -Dm 444 assets/kanata-icon.svg $out/share/icons/hicolor/scalable/apps/kanata.svg
  '';

  checkFlags = [
    "--skip=kanata::tcp_layer_change_tests"
  ];

  meta = {
    description = "Tool to improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = lib.licenses.lgpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "kanata";
  };
})
