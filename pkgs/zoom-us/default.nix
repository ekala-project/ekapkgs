{
  lib,
  stdenv,
  fetchurl,
  buildFHSEnv,
  # Runtime dependencies
  alsa-lib,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  glib,
  gtk3,
  ibus,
  libGL,
  libGLU,
  libatomic_ops,
  libdrm,
  libgbm,
  libkrb5,
  libsm,
  libxi,
  libxkbcommon,
  libxslt,
  mesa-demos,
  nspr,
  nss,
  pango,
  pciutils,
  pipewire,
  qt6,
  udev,
  wayland,
  libx11,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxrender,
  libxtst,
  libxshmfence,
  libxcb,
  libxcb-util,
  libxcb-cursor,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-wm,
  zlib,
  zstd,
  libpulseaudio,
  pulseaudio,
  pulseaudioSupport ? true,
}:

let
  version = "7.1.5.4332";

  src = fetchurl {
    url = "https://zoom.us/client/${version}/zoom_x86_64.pkg.tar.xz";
    hash = "sha256-5znZNrySgRrs9I5zhqN5p5dPfXpEHXKf8o2dWeYTPso=";
  };

  unpacked = stdenv.mkDerivation {
    pname = "zoom-us-unwrapped";
    inherit version src;

    dontUnpack = true;
    dontPatchELF = true;

    installPhase = ''
      runHook preInstall
      mkdir $out
      tar -C $out -xf $src
      mv $out/usr/* $out/
      runHook postInstall
    '';

    meta = {
      homepage = "https://zoom.us/";
      description = "zoom.us video conferencing application";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
      mainProgram = "zoom";
    };
  };

  runtimeDeps = [
    alsa-lib
    at-spi2-core
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    glib
    gtk3
    ibus
    libGL
    libGLU
    libatomic_ops
    libdrm
    libgbm
    libkrb5
    libsm
    libxi
    libxkbcommon
    libxslt
    mesa-demos
    nspr
    nss
    pango
    pciutils
    pipewire
    qt6.qtbase
    qt6.qtdeclarative
    stdenv.cc.cc
    udev
    wayland
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxrender
    libxtst
    libxshmfence
    libxcb
    libxcb-util
    libxcb-cursor
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm
    zlib
    zstd
  ]
  ++ lib.optionals pulseaudioSupport [
    libpulseaudio
    pulseaudio
  ];
in
buildFHSEnv {
  pname = "zoom-us";
  inherit version;

  targetPkgs = pkgs: runtimeDeps ++ [ unpacked ];
  extraPreBwrapCmds = "unset QT_PLUGIN_PATH";
  extraBwrapArgs = [ "--ro-bind ${unpacked}/opt /opt" ];
  runScript = "/opt/zoom/ZoomLauncher";

  extraInstallCommands = ''
    cp -Rt $out/ ${unpacked}/share
    substituteInPlace \
        $out/share/applications/Zoom.desktop \
        --replace-fail Exec={/usr/bin/,}zoom

    # Backwards compatibility: we also call it zoom-us
    ln -s $out/bin/{zoom,zoom-us}
  '';

  passthru = {
    inherit unpacked;
  };

  meta = unpacked.meta;
}
