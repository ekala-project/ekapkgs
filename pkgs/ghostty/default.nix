{
  lib,
  stdenv,
  blueprint-compiler,
  bzip2,
  callPackage,
  fetchFromGitHub,
  fontconfig,
  freetype,
  glib,
  glslang,
  gstreamer,
  gtk4,
  gtk4-layer-shell,
  harfbuzz,
  libadwaita,
  libGL,
  libxml2,
  ncurses,
  oniguruma,
  pkg-config,
  removeReferencesTo,
  xorg,
  zig,
  llvm,
  python3Packages,

  # Upstream recommends a non-default level
  # https://github.com/ghostty-org/ghostty/blob/4b4d4062dfed7b37424c7210d1230242c709e990/PACKAGING.md#build-options
  optimizeLevel ? "ReleaseFast",
}:
let
  # Workaround: zig needs llvm.dev for llvm-config but corepkgs zig
  # only lists llvm (not llvm.dev) in nativeBuildInputs.
  zig_0_15 = zig.v0_15.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ llvm.v20.pkgs.llvm.dev ];
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ghostty";
  version = "1.3.1";

  outputs = [
    "out"
    "shell_integration"
    "terminfo"
    "vim"
  ];

  src = fetchFromGitHub {
    owner = "ghostty-org";
    repo = "ghostty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+ddMmUe9Jjkun4qqW8XFXVgwVZdVHsGWcQzndgIlBjQ=";
  };

  deps = callPackage ./deps.nix {
    name = "${finalAttrs.pname}-cache-${finalAttrs.version}";
  };

  strictDeps = true;

  nativeBuildInputs = [
    ncurses
    pkg-config
    removeReferencesTo
    zig_0_15

    # GTK frontend
    glib # Required for `glib-compile-schemas`
    gtk4
    gtk4.wrapGAppsHook
    blueprint-compiler
    libadwaita
    libxml2 # `xmllint`
  ];

  buildInputs = [
    oniguruma

    # GTK frontend
    libadwaita
    xorg.libX11
    gtk4-layer-shell
    gstreamer
    gstreamer.plugins-good
    gstreamer.plugins-base

    # OpenGL renderer
    glslang
    libGL

    # Font backend
    bzip2
    fontconfig
    freetype
    harfbuzz
  ];

  # Don't use the ekapkgs zig setup-hook phases since we need custom flags
  dontUseZigBuild = true;
  dontUseZigInstall = true;

  configurePhase = ''
    runHook preConfigure
    export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-cache"
    export ZIG_LOCAL_CACHE_DIR="$TMPDIR/zig-local-cache"
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    # blueprint-compiler needs pygobject (gi module) on PYTHONPATH
    export PYTHONPATH="${python3Packages.pygobject3}/${python3Packages.python.sitePackages}''${PYTHONPATH:+:$PYTHONPATH}"
    zig build \
      --system "${finalAttrs.deps}" \
      -Dversion-string=${finalAttrs.version} \
      -Dcpu=baseline \
      -Doptimize=${optimizeLevel} \
      -Dpie=true \
      -Demit-docs=false \
      -fsys=glslang --search-prefix ${lib.getLib glslang}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    zig build install --prefix "$out" \
      --system "${finalAttrs.deps}" \
      -Dversion-string=${finalAttrs.version} \
      -Dcpu=baseline \
      -Doptimize=${optimizeLevel} \
      -Dpie=true \
      -Demit-docs=false \
      -fsys=glslang --search-prefix ${lib.getLib glslang}
    runHook postInstall
  '';

  postFixup = ''
    # Move terminfo to its own output
    mkdir -p $terminfo/share
    mv $out/share/terminfo $terminfo/share/terminfo
    ln -s $terminfo/share/terminfo $out/share/terminfo

    # Move shell integration to its own output
    mkdir -p $shell_integration
    mv $out/share/ghostty/shell-integration $shell_integration
    ln -s $shell_integration $out/share/ghostty/shell-integration

    # Move vim plugins to their own output
    if [ -d "$out/share/vim/vimfiles" ]; then
      mv $out/share/vim/vimfiles $vim
      rmdir $out/share/vim
      ln -s $vim $out/share/vim-plugins
    fi

    # Remove references to the zig deps cache
    if [ -f "$out/bin/.ghostty-wrapped" ]; then
      remove-references-to -t ${finalAttrs.deps} $out/bin/.ghostty-wrapped
    elif [ -f "$out/bin/ghostty" ]; then
      remove-references-to -t ${finalAttrs.deps} $out/bin/ghostty
    fi

    # Fix desktop file paths
    if [ -f "$out/share/applications/com.mitchellh.ghostty.desktop" ]; then
      substituteInPlace $out/share/applications/com.mitchellh.ghostty.desktop \
        --replace-fail "Exec=$out/bin/ghostty" "Exec=ghostty"
    fi
  '';

  meta = {
    description = "Fast, native, feature-rich terminal emulator pushing modern features";
    longDescription = ''
      Ghostty is a terminal emulator that differentiates itself by being
      fast, feature-rich, and native. While there are many excellent terminal
      emulators available, they all force you to choose between speed,
      features, or native UIs. Ghostty provides all three.
    '';
    homepage = "https://ghostty.org/";
    donationPage = "https://ghostty.org/docs/sponsor";
    downloadPage = "https://ghostty.org/download";
    changelog = "https://ghostty.org/docs/install/release-notes/${
      builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }";
    license = lib.licenses.mit;
    mainProgram = "ghostty";
    outputsToInstall = [
      "out"
    ];
    platforms = lib.platforms.linux;
  };
})
