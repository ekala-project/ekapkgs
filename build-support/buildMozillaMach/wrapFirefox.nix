# wrapFirefox -- wraps a Mozilla browser (Firefox, Thunderbird, etc.)
# with runtime library paths, desktop entries, policies, and prefs.
{
  stdenv,
  lib,
  makeDesktopItem,
  makeWrapper,
  lndir,
  config,
  buildPackages,
  jq,
  xdg-utils,
  writeText,

  ## Runtime libraries
  ffmpeg_7,
  ffmpeg_8,
  libxxf86vm,
  libxxf86dga,
  libxt,
  libxscrnsaver,
  libxext,
  libx11,
  alsa-lib,
  libpulseaudio,
  libcanberra-gtk3,
  libdbusmenu-gtk3,
  libglvnd,
  libnotify,
  opensc,
  adwaita-icon-theme,
  pipewire,
  udev,
  libkrb5,
  libva,
  libgbm,
  cups,
  pciutils,
  vulkan-loader,
  sndio,
  libjack2,
  speechd,
  zlib,
}:

browser_:

let
  browser = browser_;
  wrapper =
    {
      applicationName ? browser.binaryName or (lib.getName browser),
      pname ? applicationName,
      version ? lib.getVersion browser,
      nameSuffix ? "",
      icon ? applicationName,
      wmClass ? applicationName,
      nativeMessagingHosts ? [ ],
      pkcs11Modules ? [ ],
      withGlvnd ? true,
      cfg ? config.${applicationName} or { },
      appDataDir ? null,

      extraPrefs ? "",
      extraPrefsFiles ? [ ],
      extraPolicies ? { },
      extraPoliciesFiles ? [ ],
      extraAutoConfig ? "",
      libName ? browser.libName or applicationName,
      nixExtensions ? null,
      hasMozSystemDirPatch ? (lib.hasPrefix "firefox" pname && !lib.hasSuffix "-bin" pname),
    }:

    let
      withFFmpeg = browser.withFFmpeg or false;
      # Use ffmpeg_8 for newer Firefox, ffmpeg_7 for older
      ffmpegPackage = if lib.versionAtLeast browser.version "153.1" then ffmpeg_8 else ffmpeg_7;
      withGSSAPI = browser.withGSSAPI or false;
      withALSA = browser.withALSA or false;
      withPipewire = browser.withPipewire or false;
      withSndio = browser.withSndio or false;
      withJACK = browser.withJACK or false;
      withPCSC = cfg.smartcardSupport or false;

      allNativeMessagingHosts = map lib.getBin (lib.unique nativeMessagingHosts);

      libs =
        [
          udev
          libva
          libgbm
          libnotify
          libdbusmenu-gtk3
          libxscrnsaver
          cups
          pciutils
          vulkan-loader
        ]
        ++ lib.optional (cfg.speechSynthesisSupport or true) speechd
        ++ lib.optional withPipewire pipewire
        ++ lib.optional withFFmpeg ffmpegPackage
        ++ lib.optional withGSSAPI libkrb5
        ++ lib.optional withGlvnd libglvnd
        ++ lib.optionals (cfg.enableQuakeLive or false) [
          stdenv.cc
          libx11
          libxxf86dga
          libxxf86vm
          libxext
          libxt
          alsa-lib
          zlib
        ]
        ++ lib.optional (config.pulseaudio or true) libpulseaudio
        ++ lib.optional withALSA alsa-lib
        ++ lib.optional withSndio sndio
        ++ lib.optional withJACK libjack2
        ++ lib.optional withPCSC opensc
        ++ pkcs11Modules
        ++ gtk_modules;
      gtk_modules = [ libcanberra-gtk3 ];

      launcherName = "${applicationName}${nameSuffix}";

      policiesJson = writeText "policies.json" (builtins.toJSON enterprisePolicies);

      usesNixExtensions = nixExtensions != null;

      nameArray = map (a: a.name) (lib.optionals usesNixExtensions nixExtensions);

      extensions =
        if nameArray != (lib.unique nameArray) then
          throw "Firefox addon name needs to be unique"
        else if browser.enableAddonSigning || !browser.enableAddonSideload then
          throw "Nix addons are only supported with signature enforcement disabled and addon sideloading enabled (eg. LibreWolf)"
        else
          map (
            a:
            if !(builtins.hasAttr "extid" a) then
              throw "nixExtensions has an invalid entry. Missing extid attribute. Please use fetchFirefoxAddon"
            else
              a
          ) (lib.optionals usesNixExtensions nixExtensions);

      enterprisePolicies = {
        policies =
          lib.optionalAttrs usesNixExtensions {
            ExtensionSettings = {
              "*" = {
                blocked_install_message = "You can't have manual extension mixed with nix extensions";
                installation_mode = "blocked";
              };
            }
            // lib.foldr (
              e: ret:
              ret
              // {
                "${e.extid}" = {
                  installation_mode = "allowed";
                };
              }
            ) { } extensions;

            Extensions = {
              Install = lib.foldr (e: ret: ret ++ [ "${e.outPath}/${e.extid}.xpi" ]) [ ] extensions;
            };
          }
          // lib.optionalAttrs withPCSC {
            SecurityDevices = {
              "OpenSC PKCS#11 Module" = "opensc-pkcs11.so";
            };
          }
          // extraPolicies;
      };

      mozillaCfg = ''
        // First line must be a comment

        // Disables addon signature checking
        // to be able to install addons that do not have an extid
        // Security is maintained because only user whitelisted addons
        // with a checksum can be installed
        ${lib.optionalString usesNixExtensions ''lockPref("xpinstall.signatures.required", false);''}
      '';

    in
    stdenv.mkDerivation (finalAttrs: {
      __structuredAttrs = true;
      strictDeps = true;
      inherit pname version;

      desktopItem = makeDesktopItem (
        if lib.strings.hasPrefix "thunderbird" libName then
          {
            name = launcherName;
            exec = "${launcherName} --name ${wmClass} %U";
            inherit icon;
            desktopName = browser.applicationName;
            startupNotify = true;
            startupWMClass = wmClass;
            terminal = false;
            genericName = "Email Client";
            comment = "Read and write e-mails or RSS feeds, or manage tasks on calendars.";
            categories = [
              "Network"
              "Chat"
              "Email"
              "Feed"
              "GTK"
              "News"
            ];
            keywords = [
              "mail"
              "email"
              "e-mail"
              "messages"
              "rss"
              "calendar"
              "address book"
              "addressbook"
              "chat"
            ];
            mimeTypes = [
              "message/rfc822"
              "x-scheme-handler/mailto"
              "text/calendar"
              "text/x-vcard"
            ];
            actions = {
              profile-manager-window = {
                name = "Profile Manager";
                exec = "${launcherName} --ProfileManager";
              };
            };
          }
        else
          {
            name = launcherName;
            exec = "${launcherName} --name ${wmClass} %U";
            inherit icon;
            desktopName = browser.applicationName;
            startupNotify = true;
            startupWMClass = wmClass;
            terminal = false;
            genericName = "Web Browser";
            categories = [
              "Network"
              "WebBrowser"
            ];
            mimeTypes = [
              "text/html"
              "text/xml"
              "application/xhtml+xml"
              "application/vnd.mozilla.xul+xml"
              "x-scheme-handler/http"
              "x-scheme-handler/https"
            ];
            actions = {
              new-window = {
                name = "New Window";
                exec = "${launcherName} --new-window %U";
              };
              new-private-window = {
                name = "New Private Window";
                exec = "${launcherName} --private-window %U";
              };
              profile-manager-window = {
                name = "Profile Manager";
                exec = "${launcherName} --ProfileManager";
              };
            };
          }
      );

      nativeBuildInputs = [
        makeWrapper
        lndir
        jq
      ];
      buildInputs = [ browser.gtk3 ];

      makeWrapperArgs = [
        "--prefix"
        "LD_LIBRARY_PATH"
        ":"
        "${finalAttrs.libs}"

        "--suffix"
        "PATH"
        ":"
        "${placeholder "out"}/bin"

        "--set"
        "MOZ_APP_LAUNCHER"
        launcherName

        "--set"
        "MOZ_LEGACY_PROFILES"
        "1"

        "--set"
        "MOZ_ALLOW_DOWNGRADE"
        "1"
      ]
      ++ lib.optionals (appDataDir != null) [
        "--set"
        "MOZ_APP_DATA"
        appDataDir
      ]
      ++ [
        "--suffix"
        "GTK_PATH"
        ":"
        "${lib.concatStringsSep ":" finalAttrs.gtk_modules}"

        "--suffix"
        "XDG_DATA_DIRS"
        ":"
        "${adwaita-icon-theme}/share"

        "--set-default"
        "MOZ_ENABLE_WAYLAND"
        "1"
      ]
      ++ lib.optionals (!xdg-utils.meta.broken) [
        "--suffix"
        "PATH"
        ":"
        "${lib.makeBinPath [ xdg-utils ]}"
      ]
      ++ lib.optionals hasMozSystemDirPatch [
        "--set"
        "MOZ_SYSTEM_DIR"
        "${placeholder "out"}/lib/mozilla"
      ]
      ++ lib.optionals (!hasMozSystemDirPatch && allNativeMessagingHosts != [ ]) [
        "--run"
        "mkdir -p \${MOZ_HOME:-~/.mozilla}/native-messaging-hosts"
      ]
      ++ lib.optionals (!hasMozSystemDirPatch) (
        lib.concatMap (ext: [
          "--run"
          "ln -sfLt \${MOZ_HOME:-~/.mozilla}/native-messaging-hosts ${ext}/lib/mozilla/native-messaging-hosts/*"
        ]) allNativeMessagingHosts
      );

      buildCommand =
        let
          executablePrefix = "bin";
          executablePath = "${executablePrefix}/${applicationName}";
          finalBinaryPath = "${executablePath}${nameSuffix}";
          sourceBinary = "${browser}/${executablePath}";
          libDir = "lib/${libName}";
          prefsDir = "${libDir}/defaults/pref";
        in
        ''
          if [ ! -x "${sourceBinary}" ]
          then
              echo "cannot find executable file \`${sourceBinary}'"
              exit 1
          fi

          # Link the runtime
          cd "${browser}"
          find . -type d -exec mkdir -p "$out"/{} \;

          find . -type f \( -not -name "${applicationName}" \) -exec ln -sT "${browser}"/{} "$out"/{} \;

          find . -type f \( -name "${applicationName}" -o -name "${applicationName}-bin" \) -print0 | while read -d $'\0' f; do
            cp -P --no-preserve=mode,ownership --remove-destination "${browser}/$f" "$out/$f"
            chmod a+rwx "$out/$f"
          done

          find . -type l -print0 | while read -d $'\0' l; do
            target="$(readlink "$l")"
            target=''${target/#"${browser}"/"$out"}
            ln -sfT "$target" "$out/$l"
          done

          touch "$out/${libDir}/is-packaged-app"

          cd "$out"

          # create the wrapper
          executablePrefix="$out/${executablePrefix}"
          executablePath="$out/${executablePath}"
          oldWrapperArgs=()

          if [[ -L $executablePath ]]; then
            oldExe="$(readlink -v --canonicalize-existing "$executablePath")"
            rm "$executablePath"
          elif wrapperCmd=$(${buildPackages.makeBinaryWrapper.extractCmd} "$executablePath"); [[ $wrapperCmd ]]; then
            parseMakeCWrapperCall() {
              shift # makeCWrapper
              oldExe=$1; shift
              oldWrapperArgs=("$@")
            }
            eval "parseMakeCWrapperCall ''${wrapperCmd//"${browser}"/"$out"}"
            rm "$executablePath"
          else
            if read -rn2 shebang < "$executablePath" && [[ $shebang == '#!' ]]; then
              sed -i "s@${browser}@$out@g" "$executablePath"
            fi
            oldExe="$executablePrefix/.${applicationName}"-old
            mv "$executablePath" "$oldExe"
          fi

          appendToVar makeWrapperArgs --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
          concatTo makeWrapperArgs oldWrapperArgs

          makeWrapper "$oldExe" "$out/${finalBinaryPath}" "''${makeWrapperArgs[@]}"

          if [ -e "${browser}/share/icons" ]; then
              mkdir -p "$out/share"
              ln -s "${browser}/share/icons" "$out/share/icons"
          else
              for res in 16 32 48 64 128; do
              mkdir -p "$out/share/icons/hicolor/''${res}x''${res}/apps"
              icon=$( find "${browser}/lib/" -name "default''${res}.png" )
                if [ -e "$icon" ]; then ln -s "$icon" \
                  "$out/share/icons/hicolor/''${res}x''${res}/apps/${icon}.png"
                fi
              done
          fi

          install -m 644 -D -t $out/share/applications $desktopItem/share/applications/*

        ''
        + lib.optionalString hasMozSystemDirPatch ''
          mkdir -p $out/lib/mozilla/native-messaging-hosts
          for ext in ${toString allNativeMessagingHosts}; do
              ln -sLt $out/lib/mozilla/native-messaging-hosts $ext/lib/mozilla/native-messaging-hosts/*
          done
        ''
        + ''

          mkdir -p $out/lib/mozilla/pkcs11-modules
          for ext in ${toString pkcs11Modules}; do
              ln -sLt $out/lib/mozilla/pkcs11-modules $ext/lib/mozilla/pkcs11-modules/*
          done

          # user customization
          libDir="$out/${libDir}"

          mkdir -p "$libDir/distribution"

          POL_PATH="$libDir/distribution/policies.json"
          rm -f "$POL_PATH"
          cat ${policiesJson} >> "$POL_PATH"

          extraPoliciesFiles=(${toString extraPoliciesFiles})
          for extraPoliciesFile in "''${extraPoliciesFiles[@]}"; do
            jq -s '.[0] * .[1]' $extraPoliciesFile "$POL_PATH" > .tmp.json
            mv .tmp.json "$POL_PATH"
          done

          prefsDir="$out/${prefsDir}"
          mkdir -p "$prefsDir"

          cat > "$prefsDir/autoconfig.js" << EOF
          pref("general.config.filename", "mozilla.cfg");
          pref("general.config.obscure_value", 0);
          ${extraAutoConfig}
          EOF

          cat > "$libDir/mozilla.cfg" << EOF
          ${mozillaCfg}
          EOF

          extraPrefsFiles=(${toString extraPrefsFiles})
          for extraPrefsFile in "''${extraPrefsFiles[@]}"; do
            cat "$extraPrefsFile" >> "$libDir/mozilla.cfg"
          done

          cat >> "$libDir/mozilla.cfg" << EOF
          ${extraPrefs}
          EOF

          mkdir -p "$libDir/distribution/extensions"
        '';

      preferLocalBuild = true;

      libs = lib.makeLibraryPath libs + ":" + lib.makeSearchPathOutput "lib" "lib64" libs;
      gtk_modules = map (x: x + x.gtkModule) gtk_modules;

      passthru = {
        unwrapped = browser;
      };

      disallowedRequisites = [ stdenv.cc ];
      meta = browser.meta // {
        mainProgram = launcherName;
        hydraPlatforms = [ ];
        priority = (browser.meta.priority or lib.meta.defaultPriority) - 1;
      };
    });
in
lib.makeOverridable wrapper
