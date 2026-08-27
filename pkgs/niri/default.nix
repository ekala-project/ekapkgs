{
  lib,
  dbus,
  eudev,
  fetchFromGitHub,
  installShellFiles,
  libdisplay-info,
  libglvnd,
  libinput,
  libxkbcommon,
  libgbm,
  pango,
  pipewire,
  pkg-config,
  rustPlatform,
  seatd,
  stdenv,
  systemd,
  wayland,
  withDbus ? true,
  withDinit ? false,
  # TODO: pipewire currently fails to build (modemmanager dep broken); disable screencast until fixed
  withScreencastSupport ? false,
  # TODO: systemd fails to build (clang-wrapper-21 dep broken); disable until fixed
  withSystemd ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "niri";
  version = "26.04";

  src = fetchFromGitHub {
    owner = "niri-wm";
    repo = "niri";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ehSMsSpE+0k8r+2Vseu8kangsYxToZv3vinynsDp9zs=";
  };

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
    patchShebangs resources/niri-session
    substituteInPlace resources/niri.service \
      --replace-fail 'niri' "$out/bin/niri"
  '';

  cargoHash = "sha256-gfnalA3qI3a9h3PvsxgQLCrzapfjLLkxhTMJpwRh+ro=";

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libdisplay-info
    libglvnd
    libinput
    libxkbcommon
    libgbm
    pango
    seatd
    wayland
  ]
  ++ lib.optional (withDbus || withScreencastSupport || withSystemd) dbus
  ++ lib.optional withScreencastSupport pipewire
  ++ lib.optional withSystemd systemd
  ++ lib.optional (!withSystemd) eudev;

  buildFeatures =
    lib.optional withDbus "dbus"
    ++ lib.optional withDinit "dinit"
    ++ lib.optional withScreencastSupport "xdp-gnome-screencast"
    ++ lib.optional withSystemd "systemd";
  buildNoDefaultFeatures = true;

  postInstall = ''
    install -Dm0644 README.md resources/default-config.kdl -t $doc/share/doc/niri
    mv docs/wiki $doc/share/doc/niri/wiki

    install -Dm0644 resources/niri.desktop -t $out/share/wayland-sessions
  ''
  + lib.optionalString withDbus ''
    install -Dm0644 resources/niri-portals.conf -t $out/share/xdg-desktop-portal
  ''
  + lib.optionalString (withSystemd || withDinit) ''
    install -Dm0755 resources/niri-session -t $out/bin
  ''
  + lib.optionalString withSystemd ''
    install -Dm0644 resources/niri{-shutdown.target,.service} -t $out/lib/systemd/user
  ''
  + lib.optionalString withDinit ''
    install -Dm0644 resources/dinit/niri{-shutdown,} -t $out/lib/dinit.d/user
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd $pname \
      --bash <($out/bin/niri completions bash) \
      --fish <($out/bin/niri completions fish) \
      --zsh <($out/bin/niri completions zsh)
  '';

  env = {
    RUSTFLAGS = toString (
      map (arg: "-C link-arg=" + arg) [
        "-Wl,--push-state,--no-as-needed"
        "-lEGL"
        "-lwayland-client"
        "-Wl,--pop-state"
      ]
    );

    NIRI_BUILD_COMMIT = "ekapkgs";
  };

  checkFlags = [ "--skip=::egl" ];

  passthru = {
    providedSessions = [ "niri" ];
  };

  meta = {
    description = "Scrollable-tiling Wayland compositor";
    homepage = "https://github.com/niri-wm/niri";
    changelog = "https://github.com/niri-wm/niri/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "niri";
    platforms = lib.platforms.linux;
  };
})
