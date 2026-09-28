{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  replaceVars,
  python3Packages,
  libunistring,
  harfbuzz,
  fontconfig,
  pkg-config,
  ncurses,
  libstartup_notification,
  libGL,
  libx11,
  libxrandr,
  libxinerama,
  libxcursor,
  libxkbcommon,
  libxi,
  libxext,
  wayland-protocols,
  wayland,
  xxhash,
  lcms2,
  librsync,
  openssl,
  installShellFiles,
  dbus,
  libcanberra,
  wayland-scanner,
  python3,
  simde,
  go,
  makeBinaryWrapper,
  cairo,
}:

let
  nerdFontsSymbolsOnly = fetchurl {
    url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.5.0/NerdFontsSymbolsOnly.tar.xz";
    hash = "sha256-t+8ig0YrQ18f6R1yncQS1dvjQmndLH9OHYA+QQXI2IM=";
  };
in

with python3Packages;
buildPythonApplication rec {
  pname = "kitty";
  version = "0.48.2";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty";
    tag = "v${version}";
    hash = "sha256-qNgVPpvMm8Y/nbBjVvWVuZ954ZXIuWmXhldP3w8MBhU=";
  };

  goModules =
    (go.v1_26.buildModule {
      pname = "kitty-go-modules";
      inherit src version;
      vendorHash = "sha256-BZudfNfREwNrgalaimC5Lp+UIdFS+jHFLl9mEXcHYMI=";
    }).goModules;

  buildInputs = [
    harfbuzz
    ncurses
    simde
    lcms2
    librsync
    matplotlib
    openssl.dev
    xxhash
    fontconfig
    libunistring
    libcanberra
    libx11
    libxrandr
    libxinerama
    libxcursor
    libxkbcommon
    libxi
    libxext
    wayland-protocols
    wayland
    dbus
    libGL
    cairo
  ];

  nativeBuildInputs = [
    installShellFiles
    ncurses
    pkg-config
    sphinx
    furo
    sphinx-copybutton
    sphinxext-opengraph
    sphinx-inline-tabs
    go.v1_26
    fontconfig
    makeBinaryWrapper
    wayland-scanner
  ];

  depsBuildBuild = [ pkg-config ];

  outputs = [
    "out"
    "terminfo"
    "shell_integration"
    "kitten"
  ];

  patches = [
    ./zsh-compinit.patch
    ./disable-test_ssh_bootstrap_with_different_launchers.patch
    (replaceVars ./libxkbcommon-runtime-path.patch {
      libxkbcommon = "${lib.getLib libxkbcommon}/lib/libxkbcommon.so.0";
    })
  ];

  hardeningDisable = [
    # causes redefinition of _FORTIFY_SOURCE
    "fortify3"
  ];

  env = {
    CGO_ENABLED = 0;
    GOFLAGS = "-trimpath";
    GOTOOLCHAIN = "local";
  };

  configurePhase = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"
    export GOPROXY=off
    cp -r --reflink=auto $goModules vendor
  '';

  buildPhase = ''
    runHook preBuild

    # Add the nerd font symbols
    mkdir ./fonts/
    tar -xf ${nerdFontsSymbolsOnly} -C ./fonts/ --wildcards '*.ttf'

    ${python.pythonOnBuildForHost.interpreter} setup.py linux-package \
    --egl-library='${lib.getLib libGL}/lib/libEGL.so.1' \
    --startup-notification-library='${libstartup_notification}/lib/libstartup-notification-1.so' \
    --canberra-library='${libcanberra}/lib/libcanberra.so' \
    --fontconfig-library='${fontconfig.lib}/lib/libfontconfig.so' \
    --update-check-interval=0 \
    --shell-integration=enabled\ no-rc
    ${python.pythonOnBuildForHost.interpreter} setup.py build-launcher

    runHook postBuild
  '';

  nativeCheckInputs = [
    pillow
  ];

  # Skip tests - they require a running terminal and network access
  doCheck = false;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    mkdir -p "$kitten/bin"

    cp -r linux-package/{bin,share,lib} "$out"
    cp linux-package/bin/kitten "$kitten/bin/kitten"

    # dereference the `kitty` symlink to make sure the actual executable is wrapped
    wrapProgram $(realpath "$out/bin/kitty") --suffix PATH : "$out/bin:${
      lib.makeBinPath [
        ncurses.dev
      ]
    }"

    installShellCompletion --cmd kitty \
      --bash <("$out/bin/kitty" +complete setup bash) \
      --fish <("$out/bin/kitty" +complete setup fish2) \
      --zsh  <("$out/bin/kitty" +complete setup zsh)

    mkdir -p $terminfo/share
    mv "$out/share/terminfo" $terminfo/share/terminfo

    mkdir -p "$out/nix-support"
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages

    cp -r 'shell-integration' "$shell_integration"

    runHook postInstall
  '';

  passthru = {
    tests = { };
  };

  meta = {
    homepage = "https://github.com/kovidgoyal/kitty";
    description = "Fast, feature-rich, GPU based terminal emulator";
    license = lib.licenses.gpl3Only;
    changelog = [
      "https://sw.kovidgoyal.net/kitty/changelog/"
      "https://github.com/kovidgoyal/kitty/blob/v${version}/docs/changelog.rst"
    ];
    platforms = lib.platforms.linux;
    mainProgram = "kitty";
  };
}
