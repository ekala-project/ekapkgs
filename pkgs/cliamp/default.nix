{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  alsa-lib,
  libogg,
  libvorbis,
  flac,
  mpg123,
  ffmpeg,
  yt-dlp,
}:

buildGoModule (finalAttrs: {
  pname = "cliamp";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "bjarneo";
    repo = "cliamp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+q3/AfxHtEYH/gzaiimn0gDx98vlytVsJFfYnq04U9Y=";
  };

  vendorHash = "sha256-cythuV9J/Iu+ibRVza8dQ6RHjYKa0hVllc2t6dh3hhs=";

  env.CGO_ENABLED = "1";

  ldflags = [
    "-s"
    "-X main.version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libogg
    libvorbis
    flac
    mpg123
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  postInstall = ''
    wrapProgram $out/bin/cliamp \
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          yt-dlp
        ]
      }

    install -Dm644 $src/cliamp.desktop $out/share/applications/cliamp.desktop
    install -Dm644 $src/Cliamp.png $out/share/icons/hicolor/256x256/apps/cliamp.png
  '';

  meta = {
    description = "Retro terminal music player";
    homepage = "https://github.com/bjarneo/cliamp";
    changelog = "https://github.com/bjarneo/cliamp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "cliamp";
  };
})
