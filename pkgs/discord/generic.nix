{
  version,
  branch,
  binaryName,
  desktopName,
  mkVariantPassthru,
  ...
}@variantArgs:

{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  addDriverRunpath,
  makeDesktopItem,
  wrapGAppsHook3,
  makeShellWrapper,
  makeWrapper,
  brotli,
  python3,
  runCommand,
  writeShellScript,
  writeScript,
  alsa-lib,
  atk,
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
  libpulseaudio,
  libuuid,
  libva,
  libx11,
  libxcb,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxkbcommon,
  libxrandr,
  libxrender,
  libxscrnsaver,
  libxshmfence,
  libxtst,
  libunity,
  libayatana-appindicator,
  libdbusmenu,
  nspr,
  nss,
  pango,
  pipewire,
  speechd,
  systemdLibs,
  wayland,
  withOpenASAR ? false,
  openasar ? null,
  withVencord ? false,
  vencord ? null,
  withEquicord ? false,
  equicord ? null,
  withMoonlight ? false,
  moonlight ? null,
  withTTS ? true,
  enableAutoscroll ? false,
  disableUpdates ? true,
  commandLineArgs ? "",
}:

let
  discordMods = [
    withVencord
    withEquicord
    withMoonlight
  ];
  enabledDiscordModsCount = builtins.length (lib.filter (x: x) discordMods);

  sources = lib.importJSON ./sources.json;
  platformName = if stdenv.hostPlatform.isDarwin then "osx" else "linux";
  source = sources."${platformName}-${branch}";

  src = fetchurl { inherit (source.distro) url hash; };

  moduleSrcs = lib.mapAttrs (_: mod: fetchurl { inherit (mod) url hash; }) source.modules;
  moduleVersions = lib.mapAttrs (_: mod: mod.version) source.modules;

  configDirName = lib.replaceStrings [ " " ] [ "" ] (lib.toLower binaryName);

  disableBreakingUpdates =
    runCommand "disable-breaking-updates.py"
      {
        pythonInterpreter = "${python3.interpreter}";
        configDirName = lib.toLower binaryName;
        skipModuleUpdate = lib.boolToString withOpenASAR;
        meta.mainProgram = "disable-breaking-updates.py";
      }
      ''
        mkdir -p $out/bin
        cp ${./disable-breaking-updates.py} $out/bin/disable-breaking-updates.py
        substituteAllInPlace $out/bin/disable-breaking-updates.py
        chmod +x $out/bin/disable-breaking-updates.py
      '';

  meta = {
    description = "All-in-one cross-platform voice and text chat for gamers";
    downloadPage = "https://discordapp.com/download";
    homepage = "https://discordapp.com/";
    license = lib.licenses.unfree;
    mainProgram = binaryName;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
in
assert lib.assertMsg (
  enabledDiscordModsCount <= 1
) "discord: Only one of Vencord, Equicord or Moonlight can be enabled at the same time";

if stdenv.hostPlatform.isLinux then

  stdenv.mkDerivation {
    pname = "discord-${branch}";
    inherit version src meta;

    nativeBuildInputs = [
      autoPatchelfHook
      cups
      libdrm
      libuuid
      libxdamage
      libx11
      libxscrnsaver
      libxtst
      libxcb
      libxshmfence
      wrapGAppsHook3
      makeShellWrapper
      brotli
    ];

    dontWrapGApps = true;

    buildInputs = [
      alsa-lib
      libgbm
      nspr
      nss
      libpulseaudio
    ];

    strictDeps = true;
    dontUnpack = true;

    libPath = lib.makeLibraryPath (
      [
        systemdLibs
        libpulseaudio
        libdrm
        libgbm
        stdenv.cc.cc
        alsa-lib
        atk
        cairo
        cups
        dbus
        expat
        fontconfig
        freetype
        gdk-pixbuf
        glib
        gtk3
        libglvnd
        libnotify
        libx11
        libxcomposite
        libunity
        libuuid
        libva
        libxcursor
        libxdamage
        libxext
        libxfixes
        libxi
        libxrandr
        libxrender
        libxtst
        nspr
        libxcb
        libxkbcommon
        pango
        pipewire
        libxscrnsaver
        libayatana-appindicator
        libdbusmenu
        wayland
      ]
      ++ lib.optionals withTTS [ speechd ]
    );

    autoPatchelfIgnoreMissingDeps = [
      "libssl.so.1.1"
      "libcrypto.so.1.1"
    ];

    installPhase =
      let
        stageModules = writeShellScript "discord-stage-modules" ''
          store_modules="$1"
          modules_dir="''${XDG_CONFIG_HOME:-$HOME/.config}/${configDirName}/${version}/modules"
          rm -rf "$modules_dir"
          mkdir -p "$modules_dir"
          for m in ${lib.concatStringsSep " " (lib.attrNames moduleSrcs)}; do
            ln -sn "$store_modules/$m" "$modules_dir/$m"
          done
          echo '${builtins.toJSON (lib.mapAttrs (_: mod: { installedVersion = mod; }) moduleVersions)}' \
            > "$modules_dir/installed.json"
        '';
      in
      ''
        runHook preInstall

        mkdir -p $out/{bin,opt/${binaryName},share/icons/hicolor/256x256/apps}

        brotli -d < $src | tar xf - --strip-components=1 -C $out/opt/${binaryName}
        chmod +x $out/opt/${binaryName}/${binaryName}

        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: modSrc: ''
            mkdir -p $out/opt/${binaryName}/modules/${name}
            brotli -d < ${modSrc} | tar xf - --strip-components=1 -C $out/opt/${binaryName}/modules/${name}
          '') moduleSrcs
        )}

        wrapProgramShell $out/opt/${binaryName}/${binaryName} \
            "''${gappsWrapperArgs[@]}" \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
            ${lib.optionalString withTTS ''
              --run 'if [[ "''${NIXOS_SPEECH:-default}" != "False" ]]; then NIXOS_SPEECH=True; else unset NIXOS_SPEECH; fi' \
              --add-flags "\''${NIXOS_SPEECH:+--enable-speech-dispatcher}" \
            ''} \
            ${lib.optionalString enableAutoscroll "--add-flags \"--enable-blink-features=MiddleClickAutoscroll\""} \
            --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
            --prefix LD_LIBRARY_PATH : $libPath:$out/opt/${binaryName}:${addDriverRunpath.driverLink}/lib \
            --suffix VK_ADD_DRIVER_FILES : "${addDriverRunpath.driverLink}/share/vulkan/icd.d" \
            ${lib.optionalString disableUpdates "--run ${lib.getExe disableBreakingUpdates}"} \
            --run "${stageModules} $out/opt/${binaryName}/modules" \
            --add-flags ${lib.escapeShellArg commandLineArgs}

        ln -s $out/opt/${binaryName}/${binaryName} $out/bin/
        ln -s $out/opt/${binaryName}/${binaryName} $out/bin/${lib.toLower binaryName} || true

        ln -s $out/opt/${binaryName}/discord.png $out/share/icons/hicolor/256x256/apps/discord-${branch}.png

        ln -s "$desktopItem/share/applications" $out/share/

        runHook postInstall
      '';

    postInstall =
      lib.optionalString withOpenASAR ''
        cp -f ${openasar} $out/opt/${binaryName}/resources/app.asar
      ''
      + lib.optionalString withVencord ''
        mv $out/opt/${binaryName}/resources/app.asar $out/opt/${binaryName}/resources/_app.asar
        mkdir $out/opt/${binaryName}/resources/app.asar
        echo '{"name":"discord","main":"index.js"}' > $out/opt/${binaryName}/resources/app.asar/package.json
        echo 'require("${vencord}/patcher.js")' > $out/opt/${binaryName}/resources/app.asar/index.js
      ''
      + lib.optionalString withEquicord ''
        mv $out/opt/${binaryName}/resources/app.asar $out/opt/${binaryName}/resources/_app.asar
        mkdir $out/opt/${binaryName}/resources/app.asar
        echo '{"name":"discord","main":"index.js"}' > $out/opt/${binaryName}/resources/app.asar/package.json
        echo 'require("${equicord}/desktop/patcher.js")' > $out/opt/${binaryName}/resources/app.asar/index.js
      ''
      + lib.optionalString withMoonlight ''
        mv $out/opt/${binaryName}/resources/app.asar $out/opt/${binaryName}/resources/_app.asar
        mkdir $out/opt/${binaryName}/resources/app
        echo '{"name":"discord","main":"injector.js","private": true}' > $out/opt/${binaryName}/resources/app/package.json
        echo 'require("${moonlight}/injector.js").inject(require("path").join(__dirname, "../_app.asar"));' > $out/opt/${binaryName}/resources/app/injector.js
      '';

    desktopItem = makeDesktopItem {
      name = "discord-${branch}";
      exec = binaryName;
      icon = "discord-${branch}";
      inherit desktopName;
      genericName = meta.description;
      categories = [
        "Network"
        "InstantMessaging"
      ];
      mimeTypes = [ "x-scheme-handler/discord" ];
      startupWMClass = "discord";
    };

    passthru = {
      inherit disableBreakingUpdates source moduleVersions;
    };
  }

else

  # Darwin
  let
    fixDistroSymlinks = writeScript "discord-fix-distro-symlinks.py" ''
      #!${python3.interpreter}
      import pathlib
      import sys
      import tarfile

      with tarfile.open(sys.argv[1]) as tar:
          for member in tar:
              if not member.issym():
                  continue
              parts = pathlib.PurePosixPath(member.name).parts[1:]
              if not parts:
                  continue
              path = pathlib.Path(sys.argv[2], *parts)
              path.unlink(missing_ok=True)
              path.symlink_to(member.linkname)
    '';

    stageModules = writeShellScript "discord-stage-modules" ''
      store_modules="$1"
      modules_dir="$HOME/Library/Application Support/${configDirName}/${version}/modules"
      mkdir -p "$modules_dir"
      for m in ${lib.concatStringsSep " " (lib.attrNames moduleSrcs)}; do
        ln -sfn "$store_modules/$m" "$modules_dir/$m"
      done
      echo '${builtins.toJSON (lib.mapAttrs (_: mod: { installedVersion = mod; }) moduleVersions)}' \
        > "$modules_dir/installed.json"
    '';
  in
  stdenv.mkDerivation {
    pname = "discord-${branch}";
    inherit version src meta;

    nativeBuildInputs = [
      brotli
      makeWrapper
    ];

    sourceRoot = ".";
    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications

      extractDistro() {
        local src="$1"
        local dest="$2"
        local tarball
        tarball=$(mktemp)
        brotli -d < "$src" > "$tarball"
        tar xf "$tarball" --strip-components=1 -C "$dest"

        ${fixDistroSymlinks} "$tarball" "$dest"
        rm "$tarball"
      }

      extractDistro "$src" "$out/Applications"

      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: modSrc: ''
          mkdir -p "$out/Applications/${desktopName}.app/Contents/Resources/modules/${name}"
          extractDistro ${modSrc} "$out/Applications/${desktopName}.app/Contents/Resources/modules/${name}"
        '') moduleSrcs
      )}

      mkdir -p $out/bin
      makeWrapper "$out/Applications/${desktopName}.app/Contents/MacOS/${binaryName}" "$out/bin/${binaryName}" \
        --run ${lib.getExe disableBreakingUpdates} \
        --run "${stageModules} \"$out/Applications/${desktopName}.app/Contents/Resources/modules\"" \
        --add-flags ${lib.escapeShellArg commandLineArgs}

      runHook postInstall
    '';

    postInstall =
      lib.optionalString withOpenASAR ''
        cp -f ${openasar} "$out/Applications/${desktopName}.app/Contents/Resources/app.asar"
      ''
      + lib.optionalString withVencord ''
        mv "$out/Applications/${desktopName}.app/Contents/Resources/app.asar" "$out/Applications/${desktopName}.app/Contents/Resources/_app.asar"
        mkdir "$out/Applications/${desktopName}.app/Contents/Resources/app.asar"
        echo '{"name":"discord","main":"index.js"}' > "$out/Applications/${desktopName}.app/Contents/Resources/app.asar/package.json"
        echo 'require("${vencord}/patcher.js")' > "$out/Applications/${desktopName}.app/Contents/Resources/app.asar/index.js"
      ''
      + lib.optionalString withEquicord ''
        mv "$out/Applications/${desktopName}.app/Contents/Resources/app.asar" "$out/Applications/${desktopName}.app/Contents/Resources/_app.asar"
        mkdir "$out/Applications/${desktopName}.app/Contents/Resources/app.asar"
        echo '{"name":"discord","main":"index.js"}' > "$out/Applications/${desktopName}.app/Contents/Resources/app.asar/package.json"
        echo 'require("${equicord}/desktop/patcher.js")' > "$out/Applications/${desktopName}.app/Contents/Resources/app.asar/index.js"
      ''
      + lib.optionalString withMoonlight ''
        mv "$out/Applications/${desktopName}.app/Contents/Resources/app.asar" "$out/Applications/${desktopName}.app/Contents/Resources/_app.asar"
        mkdir "$out/Applications/${desktopName}.app/Contents/Resources/app.asar"
        echo '{"name":"discord","main":"injector.js","private": true}' > "$out/Applications/${desktopName}.app/Contents/Resources/app.asar/package.json"
        echo 'require("${moonlight}/injector.js").inject(require("path").join(__dirname, "../_app.asar"));' > "$out/Applications/${desktopName}.app/Contents/Resources/app.asar/injector.js"
      '';

    passthru = {
      inherit disableBreakingUpdates source;
    };
  }
