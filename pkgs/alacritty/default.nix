{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  installShellFiles,
  makeWrapper,
  ncurses,
  pkg-config,
  python3,
  scdoc,
  expat,
  fontconfig,
  freetype,
  libGL,
  libxxf86vm,
  libxi,
  libxcursor,
  libx11,
  libxcb,
  libxkbcommon,
  wayland,
  xdg-utils,
}:
let
  rpathLibs = [
    expat
    fontconfig
    freetype
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libx11
    libxcursor
    libxi
    libxxf86vm
    libxcb
    libxkbcommon
    wayland
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "alacritty";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iZtCH2DrSs6o3AG2koI2TyC3116aMlawHFkCd0TYhas=";
  };

  cargoHash = "sha256-BX4PjZXr19SScEZhb0gWkMiJUYq8ByEuVh9RpJSRCHI=";

  nativeBuildInputs = [
    cmake
    installShellFiles
    makeWrapper
    ncurses
    pkg-config
    python3
    scdoc
  ];

  buildInputs = rpathLibs;

  outputs = [
    "out"
    "terminfo"
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace alacritty/src/config/ui_config.rs \
      --replace xdg-open ${xdg-utils}/bin/xdg-open
  '';

  checkFlags = [ "--skip=term::test::mock_term" ];

  postInstall = ''
    install -D extra/linux/Alacritty.desktop -t $out/share/applications/
    install -D extra/linux/org.alacritty.Alacritty.appdata.xml -t $out/share/appdata/
    install -D extra/logo/compat/alacritty-term.svg $out/share/icons/hicolor/scalable/apps/Alacritty.svg

    $STRIP -S $out/bin/alacritty

    patchelf --add-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/alacritty
  ''
  + ''
    installShellCompletion --zsh extra/completions/_alacritty
    installShellCompletion --bash extra/completions/alacritty.bash
    installShellCompletion --fish extra/completions/alacritty.fish

    install -dm 755 "$out/share/man/man1"
    install -dm 755 "$out/share/man/man5"

    scdoc < extra/man/alacritty.1.scd | gzip -c > $out/share/man/man1/alacritty.1.gz
    scdoc < extra/man/alacritty-msg.1.scd | gzip -c > $out/share/man/man1/alacritty-msg.1.gz
    scdoc < extra/man/alacritty.5.scd | gzip -c > $out/share/man/man5/alacritty.5.gz
    scdoc < extra/man/alacritty-bindings.5.scd | gzip -c > $out/share/man/man5/alacritty-bindings.5.gz

    install -dm 755 "$terminfo/share/terminfo/a/"
    tic -xe alacritty,alacritty-direct -o "$terminfo/share/terminfo" extra/alacritty.info
    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  dontPatchELF = true;

  meta = {
    description = "Cross-platform, GPU-accelerated terminal emulator";
    homepage = "https://github.com/alacritty/alacritty";
    license = lib.licenses.asl20;
    mainProgram = "alacritty";
    maintainers = [ ];
    changelog = "https://github.com/alacritty/alacritty/blob/v${finalAttrs.version}/CHANGELOG.md";
  };
})
