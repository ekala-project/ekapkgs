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
  ffmpeg,
  yt-dlp,
}:

buildGoModule (finalAttrs: {
  pname = "cliamp";
  version = "1.63.2";

  src = fetchFromGitHub {
    owner = "bjarneo";
    repo = "cliamp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HqFDT8jGvrKqb6bupvXqZ5ECpvColRB5dXPwcKCX4RQ=";
  };

  vendorHash = "sha256-WYyv0w5KFA15axb+NA9tClfc1H4Znj8kI2boR8XziXg=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libogg
    libvorbis
    flac
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
  '';

  meta = {
    description = "Terminal Winamp - a retro terminal music player inspired by Winamp 2.x";
    homepage = "https://github.com/bjarneo/cliamp";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "cliamp";
  };
})
