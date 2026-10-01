{
  lib,
  stdenv,
  fetchurl,
  makeShellWrapper,
  autoPatchelfHook,
  imagemagick,
  asar,
  makeDesktopItem,
  # Runtime dependencies
  alsa-lib,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libglvnd,
  libnotify,
  libxkbcommon,
  libpulseaudio,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxshmfence,
  libxtst,
  nspr,
  nss,
  pango,
  pipewire,
  systemdLibs,
  wayland,
  zlib,
  commandLineArgs ? "",
}:

let
  icon = fetchurl {
    url = "https://obsidian.md/images/obsidian-logo-gradient.svg";
    hash = "sha256-EZsBuWyZ9zYJh0LDKfRAMTtnY70q6iLK/ggXlplDEoA=";
  };

  desktopItem = makeDesktopItem {
    name = "obsidian";
    desktopName = "Obsidian";
    startupWMClass = "md.Obsidian";
    comment = "Knowledge base";
    icon = "obsidian";
    exec = "obsidian %u";
    categories = [ "Office" ];
    mimeTypes = [ "x-scheme-handler/obsidian" ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "obsidian";
  version = "1.13.4";

  src = fetchurl {
    url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${finalAttrs.version}/obsidian-${finalAttrs.version}.tar.gz";
    hash = "sha256-66wkn5SbaJSBn7tLxWV+yIkvAGzv7ZVdNKbB/+Ji8Ws=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeShellWrapper
    imagemagick
    asar
  ];

  buildInputs = [
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
    libdrm
    libgbm
    libglvnd
    libnotify
    libxkbcommon
    libpulseaudio
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxshmfence
    libxtst
    nspr
    nss
    pango
    pipewire
    systemdLibs
    wayland
    zlib
  ];

  runtimeDependencies = [
    libglvnd
    pipewire
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/obsidian

    # Patch app.asar to fix internal PDF viewer CORS issue
    asar extract resources/app.asar app-src
    substituteInPlace app-src/main.js \
      --replace-fail "supportFetchAPI: true," "supportFetchAPI: true, corsEnabled: true,"
    asar pack app-src resources/app.asar

    # Install the bundled electron app
    cp -r ./* $out/share/obsidian/

    # Create wrapper using the bundled electron binary
    wrapProgramShell $out/share/obsidian/obsidian \
      --add-flags "''${NIXOS_OZONE_WL:+''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      ${lib.optionalString (commandLineArgs != "") "--add-flags ${lib.escapeShellArg commandLineArgs}"}

    ln -s $out/share/obsidian/obsidian $out/bin/obsidian

    # Install CLI helper if present
    if [ -f obsidian-cli ]; then
      install -m 755 -D obsidian-cli $out/bin/obsidian-cli
    fi

    # Desktop file
    install -m 444 -D "${desktopItem}/share/applications/"* \
      -t $out/share/applications/

    # Icons
    for size in 16 24 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick -background none ${icon} -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/obsidian.png
    done

    runHook postInstall
  '';

  meta = {
    description = "Powerful knowledge base that works on top of a local folder of plain text Markdown files";
    homepage = "https://obsidian.md";
    downloadPage = "https://github.com/obsidianmd/obsidian-releases/releases";
    mainProgram = "obsidian";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
