{
  lib,
  stdenv,
  fetchFromCodeberg,
  runCommand,
  libGL,
  libx11,
  libevdev,
  libinput,
  libxkbcommon,
  llvm,
  pixman,
  pkg-config,
  scdoc,
  udev,
  versionCheckHook,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots,
  xwayland,
  zig,
  withManpages ? true,
  xwaylandSupport ? true,
}:
let
  # Workaround: zig needs llvm.dev for llvm-config but corepkgs zig
  # only lists llvm (not llvm.dev) in nativeBuildInputs. llvm-config
  # must be on PATH so it goes in nativeBuildInputs.
  zig' = zig.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ llvm.v21.pkgs.llvm.dev ];
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "river";
  version = "0.4.1";

  outputs = [ "out" ] ++ lib.optionals withManpages [ "man" ];

  src = fetchFromCodeberg {
    owner = "river";
    repo = "river";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EGWLJY9VPdoc4LrXkWi8cNLkahorvDeAIfSOc5yDfbU=";
  };

  strictDeps = true;

  zigDeps =
    runCommand "${finalAttrs.pname}-${finalAttrs.version}-zig-deps"
      {
        inherit (finalAttrs) src;
        nativeBuildInputs = [ zig' ];
        outputHashAlgo = null;
        outputHashMode = "recursive";
        outputHash = "sha256-cUr5Cf9XWy8C2rodcS1YqR87WQ/d1itsmM+wlGNUskc=";
      }
      ''
        export ZIG_GLOBAL_CACHE_DIR=$(mktemp -d)
        mkdir -p $ZIG_GLOBAL_CACHE_DIR/tmp
        runHook unpackPhase
        cd $sourceRoot
        zig build --fetch=all
        mv $ZIG_GLOBAL_CACHE_DIR/p $out
      '';

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    xwayland
    zig'.hook
  ]
  ++ lib.optional withManpages scdoc;

  buildInputs = [
    libGL
    libevdev
    libinput
    libxkbcommon
    pixman
    udev
    wayland
    wayland-protocols
    wayland-scanner
    wlroots
  ]
  ++ lib.optionals xwaylandSupport [
    libx11
  ];

  zigBuildFlags =
    lib.optionals withManpages [
      "-Dman-pages"
    ]
    ++ lib.optionals xwaylandSupport [
      "-Dxwayland"
    ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  postInstall = ''
    install contrib/river.desktop -Dt $out/share/wayland-sessions
  '';

  passthru = {
    providedSessions = [ "river" ];
  };

  meta = {
    description = "Non-monolithic Wayland compositor";
    homepage = "https://codeberg.org/river/river";
    donationPage = "https://codeberg.org/river/river#donate";
    longDescription = ''
      River is a non-monolithic Wayland compositor.
      Unlike other Wayland compositors, river does not combine the compositor and window manager into one program.
      Instead, users can choose any window manager implementing the river-window-management-v1 protocol.
    '';
    changelog = "https://codeberg.org/river/river/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      # source code
      gpl3Only

      # wayland protocols
      mit
    ];
    mainProgram = "river";
    platforms = lib.platforms.linux;
  };
})
