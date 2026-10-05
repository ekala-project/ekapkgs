{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  clang,
  llvmPackages,
  gitMinimal,
  makeWrapper,
  alsa-lib,
  openssl,
  testers,
  versionCheckHook,
  wtype,
  dotool,
  ydotool,
  xdotool,
  xclip,
  libnotify,
  pciutils,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "voxtype";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "peteonrails";
    repo = "voxtype";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OT0tVSi9x3U7NwgZU00mojXk3RRWxuFoezpdSknLmmU=";
  };

  cargoHash = "sha256-kJFI9sSMzaaYHuc7ze5Lkwt3ZVskM9rB9bvTon0XguU=";

  nativeBuildInputs = [
    cmake
    pkg-config
    clang
    gitMinimal # whisper.cpp cmake invokes git
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    openssl
  ];

  # whisper-rs runs bindgen against whisper.cpp headers.
  env.LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  preBuild = ''
    export CMAKE_BUILD_PARALLEL_LEVEL=$NIX_BUILD_CORES
  '';

  # Audio/voice tests need hardware and downloaded models.
  doCheck = false;

  postInstall = ''
    install -Dm644 packaging/completions/voxtype.bash \
      $out/share/bash-completion/completions/voxtype
    install -Dm644 packaging/completions/voxtype.zsh \
      $out/share/zsh/site-functions/_voxtype
    install -Dm644 packaging/completions/voxtype.fish \
      $out/share/fish/vendor_completions.d/voxtype.fish

    install -Dm644 config/default.toml \
      $out/share/voxtype/default-config.toml

    wrapProgram $out/bin/voxtype \
      --prefix PATH : ${
        lib.makeBinPath [
          wtype
          dotool
            # TODO(corepkgs): add wl-clipboard
          ydotool
          xdotool
          xclip
          libnotify
          pciutils
        ]
      }
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Push-to-talk voice-to-text for Wayland";
    homepage = "https://voxtype.io";
    changelog = "https://github.com/peteonrails/voxtype/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "voxtype";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
