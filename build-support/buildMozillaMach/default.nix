# buildMozillaMach -- builds Firefox, Thunderbird, and other Mozilla products.
#
# This is a curried function: the outer call takes package-specific options
# (pname, version, src, etc.), and returns a function that takes the full
# package set as arguments.
#
# Usage in all-packages / top-level:
#   buildMozillaMach = opts: callPackage (import ./buildMozillaMach opts) { };
#   firefox-unwrapped = buildMozillaMach { pname = "firefox"; ... };

{
  pname,
  version,
  packageVersion ? version,
  meta,
  binaryName ? "firefox",
  application ? "browser",
  applicationName ? "Firefox",
  branding ? null,
  src,
  unpackPhase ? null,
  extraPatches ? [ ],
  extraPostPatch ? "",
  extraNativeBuildInputs ? [ ],
  extraConfigureFlags ? [ ],
  extraPreConfigure ? "",
  extraBuildInputs ? [ ],
  extraMakeFlags ? [ ],
  extraPassthru ? { },
}:

let
  isElfhackPlatform =
    stdenv:
    stdenv.hostPlatform.isElf
    && (
      stdenv.hostPlatform.isi686
      || stdenv.hostPlatform.isx86_64
      || stdenv.hostPlatform.isAarch32
      || stdenv.hostPlatform.isAarch64
    );
in

{
  lib,
  pkgs,
  stdenv,
  patchelf,
  callPackage,

  # build time
  autoconf,
  buildPackages,
  cargo,
  dump_syms,
  makeBinaryWrapper,
  nodejs,
  perl,
  pkg-config,
  python3,
  runCommand,
  rustc,
  rust-cbindgen,
  rustPlatform,
  unzip,
  wasilibc,
  which,
  wrapGAppsHook3,

  # runtime
  bzip2,
  dbus,
  dbus-glib,
  file,
  fontconfig,
  freetype,
  glib,
  gnum4,
  gtk3,
  libGL,
  libGLU,
  libevent,
  libffi,
  libjpeg,
  libpng,
  libstartup_notification,
  libvpx,
  libwebp,
  nasm,
  nspr,
  nss,
  pango,
  libxt,
  libxtst,
  libxrender,
  libxi,
  libxft,
  libxext,
  libxdamage,
  libxcursor,
  libx11,
  xorgproto,
  pixman,
  zip,
  zlib,
  pkgsBuildBuild,

  # optional dependencies
  withALSA ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  withFFmpeg ? true,
  withGSSAPI ? true,
  libkrb5,
  withJACK ? stdenv.hostPlatform.isLinux,
  libjack2,
  withJemalloc ? !stdenv.hostPlatform.isMusl,
  jemalloc,
  withPipewire ? withWayland && enableWebRTC,
  withPulseaudio ? stdenv.hostPlatform.isLinux,
  libpulseaudio,
  withSndio ? stdenv.hostPlatform.isLinux,
  sndio,
  withWayland ? true,
  libxkbcommon,
  libdrm,

  # Build configuration

  ## Addon signing/sideloading
  enableAddonSigning ? true,
  enableAddonSideload ? false,

  ## Optimizations
  enableElfhack ?
    isElfhackPlatform stdenv && !(stdenv.hostPlatform.isMusl && stdenv.hostPlatform.isAarch64),
  enableLTO ? (
    stdenv.hostPlatform.isLinux && stdenv.hostPlatform.is64bit && !stdenv.hostPlatform.isRiscV
  ),
  enablePGO ? (
    stdenv.hostPlatform.isLinux
    && stdenv.hostPlatform == stdenv.buildPlatform
    && stdenv.hostPlatform.is64bit
  ),
  xvfb-run,

  ## Debugging
  enableDebug ? false,

  ## On 32bit platforms, we disable adding "-g" for easier linking.
  enableDebugSymbols ? !stdenv.hostPlatform.is32bit,

  ## Privacy knobs
  enableDataReporting ? true,
  enableLocation ? true,
  enableWebRTC ? true,
  enableNeckoWiFi ? enableLocation,

  ## Crash reporting
  enableCrashReporter ?
    enableDataReporting
    && !stdenv.hostPlatform.isLoongArch64
    && !stdenv.hostPlatform.isRiscV
    && !stdenv.hostPlatform.isMusl,
  curl,

  ## DRM / Encrypted Media Extensions
  enableEMENagbar ? true,

  enableOfficialBranding ? true,
}:

assert stdenv.cc.libc or null != null;
assert
  withPipewire
  -> !withWayland || !enableWebRTC
  -> throw "${pname}: Pipewire support depends on Wayland and WebRTC support.";
assert enableElfhack -> isElfhackPlatform stdenv;

let
  inherit (lib) enableFeature;

  # Target the LLVM version that rustc is built with for LTO.
  llvmPackages0 = rustc.llvmPackages;
  llvmPackagesBuildBuild0 = pkgsBuildBuild.rustc.llvmPackages;

  # Force the use of lld and other llvm tools for LTO
  llvmPackages = llvmPackages0.override {
    bootBintoolsNoLibc = null;
    bootBintools = null;
  };
  llvmPackagesBuildBuild = llvmPackagesBuildBuild0.override {
    bootBintoolsNoLibc = null;
    bootBintools = null;
  };

  # LTO requires LLVM bintools including ld.lld and llvm-ar.
  buildStdenv = pkgs.overrideCC llvmPackages.stdenv (
    llvmPackages.stdenv.cc.override {
      bintools = if enableLTO then buildPackages.rustc.llvmPackages.bintools else stdenv.cc.bintools;
    }
  );

  # Build the WASI sysroot for RLBox sandboxing using our helper
  wasiComponents = callPackage ./wasi-sysroot.nix {
    inherit wasilibc;
    inherit (llvmPackages) llvm;
    llvmPackages = llvmPackagesBuildBuild;
  };

  inherit (wasiComponents) wasiSysRoot wasiBin;

  distributionIni = pkgs.writeText "distribution.ini" (
    lib.generators.toINI { } {
      Global = {
        id = "nixos";
        version = "1.0";
        about = "${applicationName} for NixOS";
      };
      Preferences = {
        "app.distributor" = "nixos";
        "app.distributor.channel" = "ekapkgs";
      };
    }
  );

  defaultPrefs =
    if enableLocation then
      {
        "geo.provider.network.url" = {
          value = "https://api.beacondb.net/v1/geolocate";
          reason = "We have no Google API keys and Mozilla Location Services were retired.";
        };
      }
    else
      {
        "geo.provider.use_geoclue" = {
          value = false;
          reason = "Geolocation support has been disabled through the `enableLocation` package attribute.";
        };
      };

  defaultPrefsFile = pkgs.writeText "nixos-default-prefs.js" (
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (key: value: ''
        // ${value.reason}
        pref("${key}", ${builtins.toJSON value.value});
      '') defaultPrefs
    )
  );

  toolkit = "cairo-gtk3${lib.optionalString withWayland "-wayland"}";

in

buildStdenv.mkDerivation {
  pname = "${pname}-unwrapped";
  version = packageVersion;

  inherit src unpackPhase;

  __structuredAttrs = true;
  strictDeps = true;

  inherit meta;

  outputs = [
    "out"
  ]
  ++ lib.optionals enableCrashReporter [ "symbols" ];

  # Add another configure-build-profiling run before the final configure phase if we build with pgo
  preConfigurePhases = lib.optionals enablePGO [
    "configurePhase"
    "buildPhase"
    "profilingPhase"
  ];

  patches =
    lib.optionals (lib.versionAtLeast version "136") [ ./136-no-buildconfig.patch ]
    ++ lib.optionals (lib.versionAtLeast version "133") [ ./133-env-var-for-system-dir.patch ]
    ++ lib.optionals (lib.versionAtLeast version "139" && lib.versionOlder version "141") [
      ./139-wayland-drag-animation.patch
    ]
    ++ lib.optionals (lib.versionAtLeast version "140" && lib.versionOlder version "144") [
      ./140-bindgen-string-view.patch
    ]
    ++ lib.optionals (lib.versionAtLeast version "140" && lib.versionOlder version "140.13") [
      ./153-cbindgen-0.29.4-compat.patch
    ]
    ++ extraPatches;

  postPatch = ''
    rm -rf obj-x86_64-pc-linux-gnu
    patchShebangs mach build
  ''
  + extraPostPatch;

  patchFlags = [
    "-p1"
    "-l"
  ];

  nativeBuildInputs = [
    autoconf
    cargo
    gnum4
    llvmPackagesBuildBuild.bintools
    makeBinaryWrapper
    nodejs
    perl
    python3
    rust-cbindgen
    rustPlatform.bindgenHook
    rustc
    unzip
    which
    pkg-config
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86 [ nasm ]
  ++ lib.optionals enableCrashReporter [
    dump_syms
    patchelf
  ]
  ++ lib.optionals enablePGO [ xvfb-run ]
  ++ extraNativeBuildInputs;

  setOutputFlags = false;

  preConfigure = ''
    configureScript="$(realpath ./mach) configure"

    export MOZ_BUILD_DATE=$(head -n1 sourcestamp.txt)
    export MOZ_OBJDIR=$(pwd)/objdir
    export MOZBUILD_STATE_PATH=$TMPDIR/mozbuild
    export MOZ_NOSPAM=1
    export MOZ_APP_REMOTINGNAME="${binaryName}"

    unset AS

    export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE=system

    # RLBox WASM Sandboxing -- use our custom wasi toolchain
    export WASM_CC=${wasiBin}/bin/wasm32-unknown-wasip1-cc
    export WASM_CXX=${wasiBin}/bin/wasm32-unknown-wasip1-c++
  ''
  + lib.optionalString enablePGO ''
    if [ -e "$TMPDIR/merged.profdata" ]; then
      echo "Configuring with profiling data"
      for i in "''${!configureFlagsArray[@]}"; do
        if [[ ''${configureFlagsArray[i]} = "--enable-profile-generate=cross" ]]; then
          unset 'configureFlagsArray[i]'
        fi
      done
      appendToVar configureFlags --enable-profile-use=cross
      appendToVar configureFlags --with-pgo-profile-path=$TMPDIR/merged.profdata
      appendToVar configureFlags --with-pgo-jarlog=$TMPDIR/jarlog
    else
      echo "Configuring to generate profiling data"
      configureFlagsArray+=(
        "--enable-profile-generate=cross"
      )
    fi
  ''
  + lib.optionalString (enableOfficialBranding && !stdenv.hostPlatform.is32bit) ''
    export MOZILLA_OFFICIAL=1
  ''
  + lib.optionalString (!enableAddonSigning) ''
    export MOZ_REQUIRE_SIGNING=
  ''
  + extraPreConfigure;

  configurePlatforms = [ ];

  configureFlags = [
    "--disable-tests"
    "--disable-updater"
    "--enable-application=${application}"
    "--enable-default-toolkit=${toolkit}"
    "--with-app-name=${binaryName}"
    "--with-distribution-id=org.nixos"
    "--with-libclang-path=${lib.getLib llvmPackagesBuildBuild.libclang}/lib"
    "--with-wasi-sysroot=${wasiSysRoot}"
    "--host=${buildStdenv.buildPlatform.config}"
    "--target=${buildStdenv.hostPlatform.config}"
  ]
  ++ lib.optionals enableLTO [
    "--enable-lto=cross,full"
    "--enable-linker=lld"
  ]
  ++ lib.optional (isElfhackPlatform stdenv) (enableFeature enableElfhack "elf-hack")
  ++ lib.optional (!enableEMENagbar) "--disable-eme"
  ++ lib.optional enableAddonSideload "--allow-addon-sideload"
  ++ [
    "--enable-system-pixman"
    "--with-system-ffi"
    "--with-system-jpeg"
    "--with-system-libevent"
    "--with-system-libvpx"
    "--with-system-nspr"
    "--with-system-nss"
    "--with-system-png"
    "--with-system-webp"
    "--with-system-zlib"

    (enableFeature withALSA "alsa")
    (enableFeature withJACK "jack")
    (enableFeature withPulseaudio "pulseaudio")
    (enableFeature withSndio "sndio")
  ]
  ++ lib.optionals (lib.versionOlder version "157") [
    (enableFeature withFFmpeg "ffmpeg")
  ]
  ++ [
    (enableFeature withGSSAPI "negotiateauth")
    (enableFeature withJemalloc "jemalloc")

    (enableFeature enableCrashReporter "crashreporter")
    (enableFeature enableNeckoWiFi "necko-wifi")
    (enableFeature enableWebRTC "webrtc")

    (enableFeature enableDebug "debug")
    (if enableDebug then "--enable-profiling" else "--enable-optimize")
    (enableFeature (!enableDebug && !stdenv.hostPlatform.is32bit) "release")
    (enableFeature enableDebugSymbols "debug-symbols")
  ]
  ++ lib.optionals enableDebugSymbols [
    "--disable-strip"
    "--disable-install-strip"
  ]
  ++ lib.optional (enableOfficialBranding && branding == null) "--enable-official-branding"
  ++ lib.optional (branding != null) "--with-branding=${branding}"
  ++ extraConfigureFlags;

  buildInputs = [
    bzip2
    file
    libGL
    libGLU
    libstartup_notification
    perl
    zip
    dbus
    dbus-glib
    fontconfig
    freetype
    glib
    gtk3
    libffi
    libevent
    libjpeg
    libpng
    libvpx
    libwebp
    nspr
    nss
    pango
    libx11
    libxcursor
    libxdamage
    libxext
    libxft
    libxi
    libxrender
    libxt
    libxtst
    pixman
    xorgproto
    zlib
  ]
  ++ lib.optional withALSA alsa-lib
  ++ lib.optional withJACK libjack2
  ++ lib.optional withPulseaudio libpulseaudio
  ++ lib.optional withSndio sndio
  ++ lib.optionals withWayland [
    libxkbcommon
    libdrm
  ]
  ++ lib.optional withGSSAPI libkrb5
  ++ lib.optional withJemalloc jemalloc
  ++ extraBuildInputs;

  profilingPhase = lib.optionalString enablePGO ''
    export MOZ_PKG_FORMAT=TAR
    ./mach package
    (
      export HOME=$TMPDIR
      export LLVM_PROFDATA=llvm-profdata
      export JARLOG_FILE="$TMPDIR/jarlog"

      xvfb-run -w 10 -s "-screen 0 1920x1080x24" \
        ./mach python ./build/pgo/profileserver.py
    )
    cp ./merged.profdata $TMPDIR/merged.profdata
    ./mach clobber
  '';

  preBuild = ''
    cd objdir
  '';

  postBuild = ''
    cd ..
  '';

  makeFlags = extraMakeFlags;
  separateDebugInfo = enableDebugSymbols;
  enableParallelBuilding = true;
  env = {
    HOST_CC = "${llvmPackagesBuildBuild.stdenv.cc}/bin/cc";
    HOST_CXX = "${llvmPackagesBuildBuild.stdenv.cc}/bin/c++";
  };

  doCheck = false;

  preInstall =
    lib.optionalString enableCrashReporter ''
      ./mach buildsymbols
      mkdir -p $symbols/
      cp objdir/dist/*.crashreporter-symbols.zip $symbols/
    ''
    + ''
      cd objdir
    '';

  postInstall = ''
    # Remove SDK cruft
    rm -rf $out/share/idl $out/include $out/lib/${binaryName}-devel-*

    resourceDir=$out/lib/${binaryName}

    # Install distribution customizations
    install -Dvm644 ${distributionIni} "$resourceDir/distribution/distribution.ini"
    install -Dvm644 ${defaultPrefsFile} "$resourceDir/browser/defaults/preferences/nixos-default-prefs.js"

    cd ..
  '';

  postFixup = lib.optionalString (enableCrashReporter && buildStdenv.hostPlatform.isLinux) ''
    patchelf --add-rpath "${lib.makeLibraryPath [ curl ]}" $out/lib/${binaryName}/crashreporter
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/${binaryName} --version
  '';

  passthru = {
    inherit
      application
      applicationName
      binaryName
      enableAddonSideload
      enableAddonSigning
      extraPatches
      gtk3
      nspr
      wasiSysRoot
      withALSA
      withFFmpeg
      withGSSAPI
      withJACK
      withPipewire
      withSndio
      ;
    version = packageVersion;
  }
  // extraPassthru;

  hardeningDisable = [ "format" ];
  dontFixLibtool = true;
  dontUpdateAutotoolsGnuConfigScripts = true;
  requiredSystemFeatures = [ "big-parallel" ];
}
