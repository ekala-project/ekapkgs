{
  lib,
  stdenv,
  fetchurl,
  buildFHSEnv,
  writeShellScript,
  runCommand,
  makeShellWrapper,
  brotli,
  python3,
  addDriverRunpath,
  gtk3,
  # Runtime dependencies for targetPkgs
  libcxx,
  systemdLibs,
  libpulseaudio,
  libdrm,
  libgbm,
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
  libglvnd,
  libnotify,
  libx11,
  libxcomposite,
  libunity,
  libuuid,
  libva,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxtst,
  nspr,
  nss,
  libxcb,
  libxkbcommon,
  pango,
  pipewire,
  libxscrnsaver,
  libappindicator,
  libdbusmenu,
  wayland,
  speechd,
  # Feature flags
  withTTS ? true,
  enableAutoscroll ? false,
  commandLineArgs ? "",
}:

let
  pname = "discord";
  binaryName = "Discord";

  sources = lib.importJSON ./sources.json;
  source = sources."linux-stable";
  inherit (source) version;

  src = fetchurl { inherit (source.distro) url hash; };

  moduleSrcs = lib.mapAttrs (_: mod: fetchurl { inherit (mod) url hash; }) source.modules;
  moduleVersions = lib.mapAttrs (_: mod: mod.version) source.modules;

  configDir = "\${DISCORD_USER_DATA_DIR-\${XDG_CONFIG_HOME:-$HOME/.config}}/discord";

  stageModules = writeShellScript "discord-stage-modules" ''
    store_modules="$1"
    modules_dir="${configDir}/${version}/modules"
    rm -rf "$modules_dir"
    mkdir -p "$modules_dir"
    for m in ${lib.concatStringsSep " " (lib.attrNames moduleSrcs)}; do
      ln -sn "$store_modules/$m" "$modules_dir/$m"
    done
    echo '${builtins.toJSON (lib.mapAttrs (_: mod: { installedVersion = mod; }) moduleVersions)}' \
      > "$modules_dir/installed.json"
  '';

  disableBreakingUpdates =
    runCommand "disable-breaking-updates.py"
      {
        pythonInterpreter = python3.interpreter;
        configDirName = "discord";
        skipModuleUpdate = "false";
        meta.mainProgram = "disable-breaking-updates.py";
      }
      ''
        mkdir -p $out/bin
        cp ${./disable-breaking-updates.py} $out/bin/disable-breaking-updates.py
        substituteAllInPlace $out/bin/disable-breaking-updates.py
        chmod +x $out/bin/disable-breaking-updates.py
      '';

  targetPkgs =
    pkgs:
    (lib.attrValues {
      inherit (pkgs)
        libcxx
        systemdLibs
        libpulseaudio
        libdrm
        libgbm
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
        nss
        libxcb
        libxkbcommon
        pango
        pipewire
        libxscrnsaver
        libappindicator
        libdbusmenu
        wayland
        ;

      inherit (pkgs.stdenv.cc) cc;
    })
    ++ lib.optionals withTTS [ pkgs.speechd ];

  unwrapped = stdenv.mkDerivation {
    pname = "${pname}-unwrapped";
    inherit version src;

    nativeBuildInputs = [
      makeShellWrapper
      brotli
    ];

    strictDeps = true;
    dontUnpack = true;
    dontPatchELF = true;
    dontStrip = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,opt/${binaryName},share/icons/hicolor/256x256/apps}

      brotli -d < $src | tar xf - --strip-components=1 -C $out/opt/${binaryName}
      chmod +x $out/opt/${binaryName}/${binaryName}

      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: src: ''
          mkdir -p $out/opt/${binaryName}/modules/${name}
          brotli -d < ${src} | tar xf - --strip-components=1 -C $out/opt/${binaryName}/modules/${name}
        '') moduleSrcs
      )}

      mkdir -p $out/opt/${binaryName}/modules/discord_krisp/KMS/logs

      wrapProgramShell $out/opt/${binaryName}/${binaryName} \
          --run 'case ":''${XDG_CURRENT_DESKTOP:-}:" in *:KDE:*) discordKdeWayland=1 ;; *) unset discordKdeWayland ;; esac' \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
          --add-flags "\''${WAYLAND_DISPLAY:+\''${discordKdeWayland:+--force-device-scale-factor=1}}" \
          ${lib.strings.optionalString withTTS ''
            --run 'if [[ "''${NIXOS_SPEECH:-default}" != "False" ]]; then NIXOS_SPEECH=True; else unset NIXOS_SPEECH; fi' \
            --add-flags "\''${NIXOS_SPEECH:+--enable-speech-dispatcher}" \
          ''} \
          ${lib.strings.optionalString enableAutoscroll "--add-flags \"--enable-blink-features=MiddleClickAutoscroll\""} \
          --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
          --prefix LD_LIBRARY_PATH : $out/opt/${binaryName}:${addDriverRunpath.driverLink}/lib \
          --suffix VK_ADD_DRIVER_FILES : "${addDriverRunpath.driverLink}/share/vulkan/icd.d" \
          --run ${lib.getExe disableBreakingUpdates} \
          --run "${stageModules} $out/opt/${binaryName}/modules" \
          --run '[ -t 1 ] || exec > /dev/null 2>&1' \
          --add-flags ${lib.escapeShellArg commandLineArgs}

      ln -s $out/opt/${binaryName}/${binaryName} $out/bin/
      ln -s $out/opt/${binaryName}/${binaryName} $out/bin/${lib.strings.toLower binaryName} || true

      ln -s $out/opt/${binaryName}/discord.png $out/share/icons/hicolor/256x256/apps/${pname}.png

      runHook postInstall
    '';

    meta = {
      description = "All-in-one cross-platform voice and text chat for gamers";
      downloadPage = "https://discordapp.com/download";
      homepage = "https://discordapp.com/";
      license = lib.licenses.unfree;
      mainProgram = binaryName;
      platforms = [ "x86_64-linux" ];
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  };
in
buildFHSEnv {
  inherit
    pname
    version
    ;
  inherit (unwrapped) meta;
  inherit targetPkgs;

  src = fetchurl { inherit (source.distro) url hash; };

  extraInstallCommands = ''
    ln -s ${unwrapped}/share $out/share

    ln -s $out/bin/${binaryName} $out/bin/${lib.strings.toLower binaryName} || true
  '';

  executableName = binaryName;

  runScript = "${unwrapped}/bin/${binaryName}";

  passthru = {
    inherit
      disableBreakingUpdates
      stageModules
      source
      moduleVersions
      ;
    unwrappedDiscord = unwrapped;
  };
}
