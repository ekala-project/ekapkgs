{
  lib,
  stdenv,
  fetchurl,
  squashfs-tools,
  makeShellWrapper,
  wrapGAppsHook3,
  openssl,
  nspr,
  nss,
  ffmpeg,
  pango,
  cairo,
  gdk-pixbuf,
  gtk3,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  glib,
  harfbuzz,
  libdbusmenu,
  libdrm,
  libgcrypt,
  libglvnd,
  libnotify,
  libpng,
  libpulseaudio,
  libxkbcommon,
  libgbm,
  alsa-lib,
  at-spi2-core,
  libx11,
  libxcb,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxscrnsaver,
  libxshmfence,
  libxtst,
  zlib,
  zenity,
  libayatana-appindicator,
  libsm,
  libice,
  systemdLibs,
  # High-DPI support
  deviceScaleFactor ? null,
}:

let
  deps = [
    alsa-lib
    at-spi2-core
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    libayatana-appindicator
    libdbusmenu
    libdrm
    libgcrypt
    libglvnd
    libnotify
    libpng
    libpulseaudio
    libxkbcommon
    libgbm
    nss
    pango
    systemdLibs
    libice
    libsm
    libx11
    libxcb
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxscrnsaver
    libxshmfence
    libxtst
    zlib
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "spotify";
  version = "1.2.92.147.g5b8f9367";

  # Snap revision
  rev = "97";

  src = fetchurl {
    name = "spotify-${finalAttrs.version}-${finalAttrs.rev}.snap";
    url = "https://api.snapcraft.io/api/v1/snaps/download/pOBIoZ2LrCB3rDohMxoYGnbN14EHOgD7_${finalAttrs.rev}.snap";
    hash = "sha512-Gk0/WjfgJZIG+2w4teaznAk/7evOXUsuCikDvOhmhAQ5ksQV99VeiYnE+OJf7hHnrPaHoueERvIkk7Psed/kwA==";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    makeShellWrapper
    squashfs-tools
  ];

  dontStrip = true;
  dontPatchELF = true;

  unpackPhase = ''
    runHook preUnpack
    unsquashfs "$src" '/usr/share/spotify' '/usr/bin/spotify' '/meta/snap.yaml'
    cd squashfs-root
    if ! grep -q 'grade: stable' meta/snap.yaml; then
      echo "The snap package is marked as unstable:"
      grep 'grade: ' meta/snap.yaml
      exit 1
    fi
    runHook postUnpack
  '';

  # Prevent double wrapping
  dontWrapGApps = true;

  env = rec {
    libdir = "${placeholder "out"}/lib/spotify";
    librarypath = "${lib.makeLibraryPath deps}:${libdir}";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $libdir
    mv ./usr/* $out/

    # Symlink OpenSSL libs with expected sonames
    ln -s ${lib.getLib openssl}/lib/libssl.so $libdir/libssl.so.1.0.0
    ln -s ${lib.getLib openssl}/lib/libcrypto.so $libdir/libcrypto.so.1.0.0
    ln -s ${nspr.out}/lib/libnspr4.so $libdir/libnspr4.so
    ln -s ${nspr.out}/lib/libplc4.so $libdir/libplc4.so

    # FFmpeg libraries
    ln -s ${ffmpeg.v7.lib}/lib/libavcodec.so* $libdir
    ln -s ${ffmpeg.v7.lib}/lib/libavformat.so* $libdir

    rpath="$out/share/spotify:$libdir"

    chmod +w "$out/share/spotify/spotify"
    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $rpath $out/share/spotify/spotify

    # Fix Icon line in the desktop file
    sed -i "s:^Icon=.*:Icon=spotify-client:" "$out/share/spotify/spotify.desktop"

    # Desktop file
    mkdir -p "$out/share/applications/"
    cp "$out/share/spotify/spotify.desktop" "$out/share/applications/"

    # Icons
    for i in 16 22 24 32 48 64 128 256 512; do
      ixi="''${i}x''${i}"
      mkdir -p "$out/share/icons/hicolor/$ixi/apps"
      ln -s "$out/share/spotify/icons/spotify-linux-$i.png" \
        "$out/share/icons/hicolor/$ixi/apps/spotify-client.png"
    done

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    wrapProgramShell $out/share/spotify/spotify \
      ''${gappsWrapperArgs[@]} \
      ${
        lib.optionalString (deviceScaleFactor != null) ''
          --add-flags "--force-device-scale-factor=${toString deviceScaleFactor}" \
        ''
      } \
      --prefix LD_LIBRARY_PATH : "$librarypath" \
      --prefix PATH : "${zenity}/bin"

    # Create bin symlink
    mkdir -p $out/bin
    ln -s $out/share/spotify/spotify $out/bin/spotify

    runHook postFixup
  '';

  meta = {
    description = "Play music from the Spotify music service";
    homepage = "https://www.spotify.com/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "spotify";
  };
})
