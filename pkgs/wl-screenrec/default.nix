# wl-screenrec — high-performance wlroots screen recording with hardware encoding
{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  libdrm,
  ffmpeg_6,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wl-screenrec";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "russelltg";
    repo = "wl-screenrec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x311y/0wRBXvpmVNRh6/TbLgHYvl1y589PNRjW2NCJc=";
  };

  cargoHash = "sha256-3/yVWVNLu03PhgJTwyeatSVY3cvGtWhwEwpvPdBGnKs=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    installShellFiles
  ];

  buildInputs = [
    wayland
    libdrm
    ffmpeg_6
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd wl-screenrec \
      --bash <($out/bin/wl-screenrec --generate-completions bash) \
      --fish <($out/bin/wl-screenrec --generate-completions fish) \
      --zsh <($out/bin/wl-screenrec --generate-completions zsh)
  '';

  meta = {
    description = "High performance wlroots screen recording, featuring hardware encoding";
    homepage = "https://github.com/russelltg/wl-screenrec";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "wl-screenrec";
  };
})
