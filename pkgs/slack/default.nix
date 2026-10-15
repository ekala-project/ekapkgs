{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  asar,
  alsa-lib,
  at-spi2-core,
  cairo,
  cups,
  curl,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libGL,
  libappindicator,
  libdrm,
  libnotify,
  libpulseaudio,
  libuuid,
  libxcb,
  libxkbcommon,
  libgbm,
  nspr,
  nss,
  pango,
  pipewire,
  systemdLibs,
  wayland,
  xdg-utils,
  libxtst,
  libxscrnsaver,
  libxrender,
  libxrandr,
  libxi,
  libxfixes,
  libxext,
  libxdamage,
  libxcursor,
  libxcomposite,
  libx11,
  libxshmfence,
  libxkbfile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "slack";
  version = "4.51.180";

  src = fetchurl {
    url = "https://downloads.slack-edge.com/desktop-releases/linux/x64/${finalAttrs.version}/slack-desktop-${finalAttrs.version}-amd64.deb";
    hash = "sha256-qkXhUXlHAzdwEqmtePCyFSw2iFLghSZ65ona+1wwjqE=";
  };

  rpath =
    lib.makeLibraryPath [
      alsa-lib
      at-spi2-core
      cairo
      cups
      curl
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libGL
      libappindicator
      libdrm
      libnotify
      libpulseaudio
      libuuid
      libxcb
      libxkbcommon
      libgbm
      nspr
      nss
      pango
      pipewire
      stdenv.cc.cc
      systemdLibs
      wayland
      libx11
      libxscrnsaver
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxrandr
      libxrender
      libxtst
      libxkbfile
      libxshmfence
    ]
    + ":${lib.getLib stdenv.cc.cc}/lib64";

  buildInputs = [
    gtk3 # needed for GSETTINGS_SCHEMAS_PATH
  ];

  nativeBuildInputs = [
    dpkg
    makeWrapper
    asar
  ];

  dontUnpack = true;
  dontBuild = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall

    # The deb file contains a setuid binary, so 'dpkg -x' doesn't work here
    dpkg --fsys-tarfile $src | tar --extract
    rm -rf usr/share/lintian

    mkdir -p $out
    mv usr/* $out

    # Otherwise it looks "suspicious"
    chmod -R g-w $out

    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath ${finalAttrs.rpath}:$out/lib/slack $file || true
    done

    # Replace the broken bin/slack symlink with a startup wrapper.
    # Make xdg-open overrideable at runtime.
    rm $out/bin/slack
    makeWrapper $out/lib/slack/slack $out/bin/slack \
      --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --add-flags "''${NIXOS_OZONE_WL:+''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer --enable-wayland-ime=true}}"

    # Move the icon to a spec-compliant location
    mkdir -p $out/share/icons/hicolor/512x512
    mv $out/share/{pixmaps,icons/hicolor/512x512/apps}

    # Fix the desktop link
    substituteInPlace $out/share/applications/slack.desktop \
      --replace-warn /usr/bin/ $out/bin/ \
      --replace-warn /usr/share/pixmaps/slack.png slack \
      --replace-warn bin/slack "bin/slack -s"

    # Prevent Un-blacklist pipewire integration to enable screen sharing on wayland.
    # https://github.com/flathub/com.slack.Slack/issues/101#issuecomment-1807073763
    sed -i -e 's/,"WebRTCPipeWireCapturer"/,"LebRTCPipeWireCapturer"/' $out/lib/slack/resources/app.asar

    runHook postInstall
  '';

  meta = {
    description = "Desktop client for Slack";
    homepage = "https://slack.com";
    changelog = "https://slack.com/release-notes";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "slack";
  };
})
