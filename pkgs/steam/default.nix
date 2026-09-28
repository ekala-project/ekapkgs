{
  lib,
  steam-unwrapped,
  buildFHSEnv,
  writeShellScript,
  runCommand,
  libx11,
  extraPkgs ? pkgs: [ ], # extra packages to add to targetPkgs
  extraLibraries ? pkgs: [ ], # extra packages to add to multiPkgs
  extraProfile ? "", # string to append to profile
  extraPreBwrapCmds ? "", # extra commands to run before calling bubblewrap
  extraBwrapArgs ? [ ], # extra arguments to pass to bubblewrap
  extraArgs ? "", # arguments to always pass to steam
  extraEnv ? { }, # Environment variables to pass to Steam
  privateTmp ? true, # if the steam bubblewrap should isolate /tmp
}:
let
  buildRuntimeEnv =
    {
      extraPkgs ? pkgs: [ ],
      extraLibraries ? pkgs: [ ],
      extraProfile ? "",
      extraPreBwrapCmds ? "",
      extraBwrapArgs ? [ ],
      extraEnv ? { },
      privateTmp ? true,
      ...
    }@args:
    buildFHSEnv (
      (removeAttrs args [
        "extraPkgs"
        "extraLibraries"
        "extraProfile"
        "extraPreBwrapCmds"
        "extraBwrapArgs"
        "extraArgs"
        "extraEnv"
      ])
      // {
        inherit privateTmp;

        multiArch = true;
        includeClosures = true;

        # https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/blob/main/docs/distro-assumptions.md#command-line-tools
        targetPkgs =
          pkgs:
          with pkgs;
          [
            bash
            coreutils
            file
            pciutils
            glibc_multi.bin
            usbutils
            # xdg-utils # currently broken in ekapkgs
            xz
            zenity

            # These are in targetPkgs (64-bit only) because their 32-bit builds
            # are broken due to i686 systemd-minimal-libs/fmt build failures
            networkmanager
            udev
            libudev0-shim
            libcap

            # crashes on startup if it can't find libx11 locale files
            (runCommand "xorg-locale" { } ''
              mkdir -p $out
              ln -s ${libx11}/share $out/share
            '')
          ]
          ++ extraPkgs pkgs;

        # https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/blob/main/docs/distro-assumptions.md#shared-libraries
        multiPkgs =
          pkgs:
          with pkgs;
          [
            glibc
            libxcrypt
            libGL

            libdrm
            libgbm
            libva
            vulkan-loader
          ]
          ++ extraLibraries pkgs;

        profile = ''
          # prevents log spam from SteamRT GTK trying to load host GIO modules
          unset GIO_EXTRA_MODULES

          # udev event notifications don't work reliably inside containers.
          # SDL2 already tries to automatically detect flatpak and pressure-vessel
          # and falls back to inotify-based discovery.
          export SDL_JOYSTICK_DISABLE_UDEV=1

          # This is needed for IME (e.g. iBus, fcitx5) to function correctly on non-CJK locales
          export GTK_IM_MODULE='xim'

          # See https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/blob/main/docs/distro-assumptions.md#graphics-driver
          export LIBGL_DRIVERS_PATH=/run/opengl-driver/lib/dri:/run/opengl-driver-32/lib/dri
          export __EGL_VENDOR_LIBRARY_DIRS=/run/opengl-driver/share/glvnd/egl_vendor.d:/run/opengl-driver-32/share/glvnd/egl_vendor.d
          export LIBVA_DRIVERS_PATH=/run/opengl-driver/lib/dri:/run/opengl-driver-32/lib/dri
          export VDPAU_DRIVER_PATH=/run/opengl-driver/lib/vdpau:/run/opengl-driver-32/lib/vdpau

          # Steam gets confused by the symlinks to bind mounts to symlinks /etc/localtime ends up being, so help it out.
          if [ -z ''${TZ+x} ]; then
            new_TZ="$(readlink -f /etc/localtime | grep -P -o '(?<=/zoneinfo/).*$')"
            if [ $? -eq 0 ]; then
              export TZ="$new_TZ"
            fi
          fi

          set -a
          ${lib.toShellVars extraEnv}
          set +a

          ${extraProfile}
        '';

        inherit extraPreBwrapCmds;

        # Steam expects /sbin/ldconfig to exist, and since SteamRT3
        # symlinking it results in a symlink loop in nested containers.
        # Thus, just copy it.
        extraBuildCommands = ''
          cp -f $out/usr/{bin,sbin}/ldconfig
        '';

        extraBwrapArgs = [
          # Steam will dump crash reports here, make those more accessible
          "--bind-try /tmp/dumps /tmp/dumps"
        ]
        ++ extraBwrapArgs;
      }
    );
in
buildRuntimeEnv {
  pname = "steam";
  inherit (steam-unwrapped) version;

  extraPkgs = pkgs: [ steam-unwrapped ] ++ extraPkgs pkgs;
  inherit
    extraLibraries
    extraProfile
    extraPreBwrapCmds
    extraBwrapArgs
    extraEnv
    privateTmp
    ;

  runScript = writeShellScript "steam-wrapped" ''
    exec steam ${extraArgs} "$@"
  '';

  extraInstallCommands = ''
    ln -s ${steam-unwrapped}/share $out/share
  '';

  passthru =
    let
      makeSteamRun =
        package:
        buildRuntimeEnv {
          inherit (steam-unwrapped) version;
          pname = "steam-run";

          extraPkgs = pkgs: package ++ extraPkgs pkgs;

          inherit
            extraLibraries
            extraProfile
            extraPreBwrapCmds
            extraBwrapArgs
            extraEnv
            privateTmp
            ;

          runScript = writeShellScript "steam-run" ''
            if [ $# -eq 0 ]; then
              echo "Usage: steam-run command-to-run args..." >&2
              exit 1
            fi

            exec "$@"
          '';

          meta = {
            description = "Run commands in the same FHS environment that is used for Steam";
            mainProgram = "steam-run";
            name = "steam-run";
            license = lib.licenses.mit;
          };
        };
    in
    {
      inherit buildRuntimeEnv;

      run = makeSteamRun [ steam-unwrapped ];
      run-free = makeSteamRun [ ];
    };

  meta = steam-unwrapped.meta;
}
