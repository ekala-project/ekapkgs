{
  stdenv,
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  meson,
  ninja,
  scdoc,
  pkg-config,
  bash,
  dmenu,
  libnotify,
  newt,
  python3Packages,
  systemd,
  util-linux,
  fumonSupport ? true,
  uuctlSupport ? true,
  uwsmAppSupport ? true,
}:
let
  python = python3Packages.python.withPackages (ps: [
    ps.pydbus
    ps.dbus-python
    ps.pyxdg
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "uwsm";
  version = "0.26.6";

  src = fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "uwsm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5wfQ2Iv4j2Gd/CV1BQ7mdkIXG7sA90iMiBAefmM3BvY=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    util-linux
    newt
    libnotify
    bash
    systemd
    python
  ]
  ++ lib.optionals uuctlSupport [ dmenu ];

  mesonFlags = [
    "--prefix=${placeholder "out"}"
  ]
  ++ (lib.mapAttrsToList lib.mesonEnable {
    "uwsm-app" = uwsmAppSupport;
    "fumon" = fumonSupport;
    "uuctl" = uuctlSupport;
    "man-pages" = true;
    "canonicalize-bins" = true;
  })
  ++ (lib.mapAttrsToList lib.mesonOption {
    "python-bin" = python.interpreter;
  });

  postInstall =
    let
      wrapperArgs = "--suffix PATH : ${lib.makeBinPath finalAttrs.buildInputs}";
    in
    lib.optionalString uuctlSupport ''
      wrapProgram $out/bin/uuctl ${wrapperArgs}
    ''
    + lib.optionalString uwsmAppSupport ''
      wrapProgram $out/bin/uwsm-app ${wrapperArgs}
    ''
    + lib.optionalString fumonSupport ''
      wrapProgram $out/bin/fumon ${wrapperArgs}
    '';

  outputs = [
    "out"
    "man"
  ];

  meta = {
    description = "Universal wayland session manager";
    homepage = "https://github.com/Vladimir-csp/uwsm";
    changelog = "https://github.com/Vladimir-csp/uwsm/releases/tag/v${finalAttrs.version}";
    mainProgram = "uwsm";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
