{
  lib,
  stdenv,
  alsa-lib,
  dbus,
  fetchFromGitHub,
  libpulseaudio ? null,
  libxcb,
  ncurses,
  openssl,
  pkg-config,
  python3,
  rustPlatform,
  ueberzug ? null,
  withALSA ? true,
  withClipboard ? true,
  withCover ? false,
  withCrossterm ? true,
  withMPRIS ? true,
  withNotify ? true,
  withPulseAudio ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ncspot";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "hrkfdn";
    repo = "ncspot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QQeiVmMRF5ql2GVR5nopKtBrTAP8K1Rjs/B89+Azg5s=";
  };

  cargoHash = "sha256-u6T5zaeN+rmTH5eM7Inpw/EZh48RauhhVhnAmUMYFIc=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optional withClipboard python3;

  buildInputs =
    [
      ncurses
      openssl
    ]
    ++ lib.optional withALSA alsa-lib
    ++ lib.optional withClipboard libxcb
    ++ lib.optional (withCover && ueberzug != null) ueberzug
    ++ lib.optional (withMPRIS || withNotify) dbus
    ++ lib.optional (withPulseAudio && libpulseaudio != null) libpulseaudio;

  buildNoDefaultFeatures = true;

  buildFeatures =
    lib.optional withALSA "alsa_backend"
    ++ lib.optional withClipboard "share_clipboard"
    ++ lib.optional withCover "cover"
    ++ lib.optional withCrossterm "crossterm_backend"
    ++ lib.optional withMPRIS "mpris"
    ++ lib.optional withNotify "notify";

  postInstall = ''
    install -D --mode=444 $src/misc/ncspot.desktop $out/share/applications/ncspot.desktop
    install -D --mode=444 $src/images/logo.svg $out/share/icons/hicolor/scalable/apps/ncspot.svg
  '';

  meta = {
    description = "Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes";
    homepage = "https://github.com/hrkfdn/ncspot";
    changelog = "https://github.com/hrkfdn/ncspot/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    mainProgram = "ncspot";
  };
})
