# Chromium browser package for ekapkgs.
#
# Ported from nixpkgs/pkgs/applications/networking/browsers/chromium/.
# This is an extremely complex package that builds from source using GN/Ninja.
# Build time: 6+ hours on a modern machine.
#
# Structure: consolidated from nixpkgs' default.nix, common.nix, browser.nix,
# and ungoogled.nix into a single file.

{
  newScope,
  config,
  stdenv,
  makeWrapper,
  buildPackages,
  ed,
  grep,
  coreutils,
  xdg-utils,
  glib,
  gtk3,
  gtk4,
  adwaita-icon-theme,
  gsettings-desktop-schemas,
  gn,
  fetchgit,
  fetchFromGitiles,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchpatch,
  fetchurl,
  fetchzip,
  zstd,
  rustPlatform,
  buildGoModule,
  libva,
  pipewire,
  wayland,
  runCommand,
  lib,
  libkrb5,

  # Build infrastructure
  ninja,
  bashInteractive,
  go,
  cargo,
  pkg-config,
  python3,
  perl,
  nodejs,
  npmHooks,
  which,
  libuuid,
  overrideCC,
  symlinkJoin,
  bison,
  gperf,

  # Build inputs
  openssl,
  libpng,
  bzip2,
  flac,
  speex,
  libopus,
  libevent,
  expat,
  libjpeg,
  snappy,
  libcap,
  minizip,
  libwebp,
  libusb1,
  re2,
  ffmpeg,
  libxslt,
  libxml2,
  nasm,
  nspr,
  nss,
  util-linux,
  alsa-lib,
  dbus-glib,
  libxscrnsaver,
  libxcursor,
  libxtst,
  libxshmfence,
  libGLU,
  libGL,
  dri-pkgconfig-stub,
  libgbm,
  pciutils,
  protobuf,
  speechd-minimal,
  libxdamage,
  at-spi2-core,
  libdrm,
  libxkbcommon,
  curl,
  libffi,
  libepoxy,
  libevdev,
  vulkan-loader,
  glibc,
  typescript,

  # Cross-compilation support
  pkgsBuildBuild,
  pkgsBuildHost,
  pkgs,

  # Package customization
  proprietaryCodecs ? true,
  enableWideVine ? false,
  ungoogled ? false,
  cupsSupport ? true,
  commandLineArgs ? "",

  # Optional dependencies
  libpulseaudio ? null,
  libgcrypt ? null,
  cups ? null,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
  systemdLibs,
}:

let
  # Use the LLVM stdenv from the Rust toolchain
  llvmStdenv = pkgs.rustc.llvmPackages.stdenv;

  upstream-info =
    (lib.importJSON ./info.json).${if !ungoogled then "chromium" else "ungoogled-chromium"};

  chromiumVersionAtLeast = min-version: lib.versionAtLeast upstream-info.version min-version;
  versionRange =
    min-version: upto-version:
    lib.versionAtLeast upstream-info.version min-version
    && lib.versionOlder upstream-info.version upto-version;

  gnChromium = gn.override upstream-info.deps.gn;

  # ---- ungoogled-chromium source patches ----
  ungoogled-chromium-src =
    { rev, hash }:
    pkgsBuildBuild.stdenv.mkDerivation {
      pname = "ungoogled-chromium";
      version = rev;

      src = fetchFromGitHub {
        owner = "ungoogled-software";
        repo = "ungoogled-chromium";
        inherit rev hash;
      };

      dontBuild = true;

      buildInputs = [
        pkgsBuildBuild.python3
        pkgsBuildBuild.patch
      ];

      nativeBuildInputs = [
        pkgsBuildBuild.makeWrapper
      ];

      patchPhase = ''
        sed -i '/chromium-widevine/d' patches/series
        substituteInPlace utils/prune_binaries.py \
          --replace-fail "KEEP_SUFFIXES = (" "KEEP_SUFFIXES = ('.patch', "
      '';

      installPhase = ''
        mkdir $out
        cp -R * $out/
        wrapProgram $out/utils/patches.py --add-flags "apply" --prefix PATH : "${pkgsBuildBuild.patch}/bin"
      '';
    };

  ungoogler = ungoogled-chromium-src {
    inherit (upstream-info.deps.ungoogled-patches) rev hash;
  };

  # ---- Python with required packages ----
  python3WithPackages = python3.pythonOnBuildForHost.withPackages (
    ps: with ps; [
      ply
      jinja2
      setuptools
    ]
  );

  # ---- GN flag serialisation ----
  mkGnFlags =
    let
      mkGnString = value: "\"${lib.escape [ "\"" "$" "\\" ] value}\"";
      sanitize =
        value:
        if value == true then
          "true"
        else if value == false then
          "false"
        else if lib.isList value then
          "[${lib.concatMapStringsSep ", " sanitize value}]"
        else if lib.isInt value then
          toString value
        else if lib.isString value then
          mkGnString value
        else
          throw "Unsupported type for GN value `${value}'.";
      toFlag = key: value: "${key}=${sanitize value}";
    in
    attrs: lib.concatStringsSep " " (lib.attrValues (lib.mapAttrs toFlag attrs));

  # ---- System libraries to unbundle ----
  gnSystemLibraries = [
    "flac"
    "libjpeg"
    "libxml"
    "libxslt"
  ];

  # ---- Build configuration ----
  packageName = "chromium";
  buildType = "Release";
  buildPath = "out/${buildType}";
  libExecPath = "$out/libexec/${packageName}";
  sandboxExecutableName = "__chromium-suid-sandbox";

  # ---- LLVM stdenv for build platform ----
  buildPlatformLlvmStdenv =
    let
      llvmPackages = pkgsBuildBuild.rustc.llvmPackages;
    in
    overrideCC llvmPackages.stdenv (
      llvmPackages.stdenv.cc.override {
        inherit (llvmPackages) bintools;
      }
    );

  # ---- Rust tools ----
  rustTools = symlinkJoin {
    name = "rustTools";
    paths = [
      buildPackages.rust-bindgen
      buildPackages.rustfmt
    ];
  };

  # ---- Crubit (Rust/C++ interop tool) ----
  _crubit =
    {
      "154" = {
        rev = "69b85cba43f85a6439dc0be86a6fe424bb07a100";
        hash = "sha256-hSN4ZW3LsN3cerv3h3whAYLDZuoE6YaLuR9WY48P3E0=";
        cargoHash = "sha256-xJWYE0gfEkf0WvrkaDkXiOYwvrlQGqa7QxkosXKH6UQ=";
      };
      "155" = {
        rev = "a355b02da81bc9f350925c73ec0322ce4d5140f1";
        hash = "sha256-Z2wsYe2Tln+CeAV9naC1QRnmvrz3HZXF06cNIp1RqU4=";
        cargoHash = "sha256-5EB6yTk+eGffjUK/TXf6ZxCU0p05Dh1nL8q3Nl6TiiY=";
      };
    }
    .${lib.versions.major upstream-info.version};

  crubit = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "crubit";
    version = "0-unstable-2026-09-11";

    src = fetchFromGitiles {
      url = "https://chromium.googlesource.com/external/github.com/google/crubit.git";
      inherit (_crubit) rev hash;
    };

    inherit (_crubit) cargoHash;

    buildInputs = [
      buildPackages.rustc.llvmPackages.llvm
    ];

    cargoBuildFlags = [
      "--bin"
      "cc_bindings_from_rs"
    ];

    cargoTestFlags = finalAttrs.cargoBuildFlags;

    env.RUSTC_BOOTSTRAP = 1;
  });

  # ---- gnrt (Rust GN integration tool) ----
  gnrt = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "gnrt";
    version = "0-unstable";

    src = chromiumDeps."src";
    sourceRoot = "tools/crates/gnrt";

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs)
        pname
        version
        src
        sourceRoot
        ;
      nativeBuildInputs = [ zstd ];
      hash = "sha256-RO1fJ4Qgt5CxcEwtZT+7SZx7XqiaAmURK3DdEnzIP2k=";
    };

    nativeBuildInputs = [
      zstd
      pkg-config
    ];

    buildInputs = [
      openssl
    ];

    meta.mainProgram = "gnrt";
  });

  # ---- esbuild (bundled version matching chromium's node_modules) ----
  _esbuild =
    {
      "154" = {
        version = "0.25.1";
        hash = "sha256-vrhtdrvrcC3dQoJM6hWq6wrGJLSiVww/CNPlL1N5kQ8=";
      };
      "155" = {
        version = "0.28.2";
        hash = "sha256-I1u+9U5Oj/KzxSjCxwyitwSuDKimatkbC3R2OtaUsfM=";
      };
    }
    .${lib.versions.major upstream-info.version};

  esbuild = buildGoModule (finalAttrs: {
    pname = "esbuild";
    inherit (_esbuild) version;

    src = fetchFromGitHub {
      owner = "evanw";
      repo = "esbuild";
      tag = "v${finalAttrs.version}";
      inherit (_esbuild) hash;
    };

    vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
  });

  # ---- Architecture mapping ----
  chromiumRosettaStone = {
    cpu =
      platform:
      let
        name = platform.parsed.cpu.name;
      in
      (
        {
          "x86_64" = "x64";
          "i686" = "x86";
          "arm" = "arm";
          "aarch64" = "arm64";
        }
        .${platform.parsed.cpu.name} or (throw "no chromium Rosetta Stone entry for cpu: ${name}")
      );
    os =
      platform:
      if platform.isLinux then
        "linux"
      else
        throw "no chromium Rosetta Stone entry for os: ${platform.config}";
  };

  rustcVersion = buildPackages.rustc.version;
  llvmVersion = buildPackages.rustc.llvmPackages.llvm.version;

  # ---- Chromium source deps (from info.json DEPS) ----
  chromiumDeps = lib.mapAttrs (
    path: args:
    fetchFromGitiles (
      removeAttrs args [ "recompress" ]
      // lib.optionalAttrs args.recompress or false {
        name = "source.tar.zstd";
        downloadToTemp = false;
        passthru.unpack = true;
        nativeBuildInputs = [ zstd ];
        postFetch = ''
          tar \
            --use-compress-program="zstd -T$NIX_BUILD_CORES" \
            --sort=name \
            --mtime="1970-01-01" \
            --owner=root --group=root \
            --numeric-owner --mode=go=rX,u+rw,a-s \
            --remove-files \
            --directory="$out" \
            -cf "$TMPDIR/source.zstd" .
          mv "$TMPDIR/source.zstd" "$out"
        '';
      }
    )
  ) upstream-info.DEPS;

  unpackPhaseSnippet = lib.concatStrings (
    lib.mapAttrsToList (
      path: dep:
      (
        if dep.unpack or false then
          ''
            mkdir -p ${path}
            pushd ${path}
            unpackFile ${dep}
            popd
          ''
        else
          ''
            mkdir -p ${dirOf path}
            cp -r ${dep}/. ${path}
          ''
      )
      + ''
        chmod u+w -R ${path}
      ''
    ) chromiumDeps
  );

  # ---- bidi module for chromedriver (not used by chromium browser, but included for completeness) ----
  bidi = fetchzip {
    url = "https://commondatastorage.googleapis.com/chromium-nodejs/chromium-bidi/e7aab7e5ac29d62f5c023d7e8ba5eedc09a11945a88b0e174fc42f64c0820071";
    extension = "tar.gz";
    stripRoot = false;
    hash = "sha256-Td9MpgNDdHTlqvmlu7v2JwkhCbN9NvSlzcbnHSSjieA=";
  };

  # ---- LLVM tools for chromium ----
  llvmCcAndBintools = symlinkJoin {
    name = "llvmCcAndBintools";
    paths = [
      buildPackages.rustc.llvmPackages.llvm
      buildPackages.rustc.llvmPackages.stdenv.cc
    ];
  };

  # ---- GN build flags ----
  gnFlags = mkGnFlags (
    {
      is_official_build = true;
      disable_fieldtrial_testing_config = true;

      host_cpu = chromiumRosettaStone.cpu llvmStdenv.buildPlatform;
      host_os = chromiumRosettaStone.os llvmStdenv.buildPlatform;
      target_cpu = chromiumRosettaStone.cpu llvmStdenv.hostPlatform;
      v8_target_cpu = chromiumRosettaStone.cpu llvmStdenv.hostPlatform;
      target_os = chromiumRosettaStone.os llvmStdenv.hostPlatform;

      custom_toolchain = "//build/toolchain/linux/unbundle:default";
      host_toolchain = "//build/toolchain/linux/unbundle:default";
    }
    // lib.optionalAttrs (llvmStdenv.buildPlatform != llvmStdenv.hostPlatform) {
      host_toolchain = "//build/toolchain/linux/unbundle:host";
      v8_snapshot_toolchain = "//build/toolchain/linux/unbundle:host";
    }
    // {
      host_pkg_config = "${pkgsBuildBuild.pkg-config}/bin/pkg-config";
      pkg_config = "${pkgsBuildHost.pkg-config}/bin/${llvmStdenv.cc.targetPrefix}pkg-config";

      use_sysroot = false;
      treat_warnings_as_errors = false;
      clang_use_chrome_plugins = false;
      symbol_level = 0;
      blink_symbol_level = 0;

      google_api_key = "AIzaSyDGi15Zwl11UNe6Y-5XW_upsfyw31qwZPI";

      use_gio = true;
      use_cups = cupsSupport;
    }
    // lib.optionalAttrs (packageName == "chromium") {
      enable_widevine = true;
    }
    // {
      rtc_use_pipewire = true;
      chrome_pgo_phase = 0;
      clang_base_path = "${llvmCcAndBintools}";

      use_clang_modules = false;
    }
    // lib.optionalAttrs (chromiumVersionAtLeast "155") {
      v8_use_metagen_instance_types = false;
    }
    // lib.optionalAttrs (chromiumVersionAtLeast "150") {
      use_unified_system_module = false;
    }
    // {
      use_qt5 = false;
      use_qt6 = false;

      clang_warning_suppression_file = "";

      use_system_libffi = true;
    }
    // lib.optionalAttrs (!chromiumVersionAtLeast "154") {
      rust_sysroot_absolute = "${buildPackages.rustc}";
    }
    // {
      rust_bindgen_root = "${rustTools}";
      enable_rust = true;
      rustc_version = rustcVersion;
    }
    // lib.optionalAttrs (!(llvmStdenv.buildPlatform.canExecute llvmStdenv.hostPlatform)) {
      arm_control_flow_integrity = "none";
    }
    // lib.optionalAttrs proprietaryCodecs {
      proprietary_codecs = true;
      enable_hangout_services_extension = true;
      ffmpeg_branding = "Chrome";
    }
    // lib.optionalAttrs llvmStdenv.hostPlatform.isAarch64 {
      use_vaapi = false;
      use_v4l2_codec = true;
    }
    // {
      use_pulseaudio = true;
      link_pulseaudio = true;
    }
    // lib.optionalAttrs (versionRange "153" "155") {
      use_typescript_go = false;
      devtools_use_typescript_go = false;
    }
    // lib.optionalAttrs ungoogled (lib.importTOML ./ungoogled-flags.toml)
  );

  # ---- Common build/runtime dependencies ----
  commonDeps = [
    (libopus.override { withCustomModes = true; })
    bzip2
    flac
    speex
    libevent
    expat
    libjpeg
    snappy
    libcap
    minizip
    libwebp
    libusb1
    re2
    ffmpeg
    libxslt
    libxml2
    nasm
    nspr
    nss
    util-linux
    alsa-lib
    libkrb5
    glib
    gtk3
    dbus-glib
    libxscrnsaver
    libxcursor
    libxtst
    libxshmfence
    libGLU
    libGL
    libgbm
    pciutils
    protobuf
    speechd-minimal
    libxdamage
    at-spi2-core
    pipewire
    libva
    libdrm
    wayland
    libxkbcommon
    curl
    libepoxy
    libffi
    libevdev
  ]
  ++ lib.optional systemdSupport systemdLibs
  ++ lib.optionals cupsSupport [
    libgcrypt
    cups
  ]
  ++ [
    libpulseaudio
  ];

  # ---- Chromium browser derivation (the core build) ----
  browser = llvmStdenv.mkDerivation {
    pname = "${lib.optionalString ungoogled "ungoogled-"}chromium-unwrapped";
    inherit (upstream-info) version;
    inherit packageName buildType buildPath;

    unpackPhase = ''
      runHook preUnpack

      ${unpackPhaseSnippet}
      sourceRoot=src

      runHook postUnpack
    '';

    npmRoot = "third_party/node";
    npmDeps =
      (fetchNpmDeps {
        src = chromiumDeps."src";
        sourceRoot = "third_party/node";
        hash = upstream-info.deps.npmHash;
      }).overrideAttrs
        (p: {
          nativeBuildInputs = p.nativeBuildInputs or [ ] ++ [ zstd ];
        });

    nativeBuildInputs = [
      ninja
      gnChromium
      bashInteractive
      pkg-config
      python3WithPackages
      perl
      which
      buildPackages.rustc.llvmPackages.bintools
      bison
      gperf
      nodejs
      npmHooks.npmConfigHook
    ]
    ++ lib.optionals (chromiumVersionAtLeast "151") [
      go
    ]
    ++ lib.optionals (chromiumVersionAtLeast "154") [
      cargo
    ];

    depsBuildBuild = [
      buildPlatformLlvmStdenv
      buildPlatformLlvmStdenv.cc
      pkg-config
      libuuid
    ]
    ++ (map (dep:
      if dep == null then null
      else if lib.isDerivation dep then dep
      else dep
    ) commonDeps);

    buildInputs = [
      dri-pkgconfig-stub
    ] ++ commonDeps;

    patches = [
      ./patches/cross-compile.patch
    ]
    ++ lib.optionals (!chromiumVersionAtLeast "153") [
      ./patches/no-build-timestamps.patch
    ]
    ++ lib.optionals (packageName == "chromium") [
      ./patches/${lib.optionalString (chromiumVersionAtLeast "150") "chromium-150-"}widevine-disable-auto-download-allow-bundle.patch
    ]
    ++ lib.optionals (!chromiumVersionAtLeast "150") [
      ./patches/angle-wayland-include-protocol.patch
    ]
    ++ [
      ./patches/chromium-initial-prefs.patch
    ]
    ++ lib.optionals (versionRange "141" "150") [
      ./patches/chromium-141-rust.patch
    ]
    ++ lib.optionals (chromiumVersionAtLeast "150") [
      ./patches/chromium-150-rust.patch
    ]
    ++ [
      ./patches/chromium-136-nodejs-assert-minimal-version-instead-of-exact-match.patch
    ]
    ++ [
      (fetchpatch {
        name = "chromium-138-rust-1.86-mismatched_lifetime_syntaxes.patch";
        url = "https://chromium.googlesource.com/chromium/src/+/94a87ff38c51fd1a71980a5051d3553978391608^!?format=TEXT";
        decode = "base64 -d";
        includes = [ "build/rust/cargo_crate.gni" ];
        hash = "sha256-xf1Jq5v3InXkiVH0uT7+h1HPwZse5MDcHKuJNjSLR6k=";
      })
    ]
    ++ lib.optionals (!chromiumVersionAtLeast "154" && !ungoogled) [
      (fetchpatch {
        name = "ungoogled-chromium-145-build-with-wasm-rollup.patch";
        url = "https://github.com/ungoogled-software/ungoogled-chromium/raw/refs/tags/145.0.7632.159-1/patches/core/ungoogled-chromium/build-with-wasm-rollup.patch";
        hash = "sha256-Ho5I33FOgtYHvKSZlWXWuBaqnSHqy4+f6EZdiL+/rRQ=";
      })
    ]
    ++ lib.optionals (versionRange "154" "155" && !ungoogled) [
      (fetchpatch {
        name = "ungoogled-chromium-154-build-with-wasm-rollup.patch";
        url = "https://github.com/ungoogled-software/ungoogled-chromium/raw/refs/tags/150.0.7871.46-1/patches/core/ungoogled-chromium/build-with-wasm-rollup.patch";
        excludes = [ "third_party/devtools-frontend/src/scripts/build/ninja/bundle.gni" ];
        hash = "sha256-o+jpDMfelVSTGcT9Ehl6zg92GOXg0cOP25MHYzOH4RQ=";
      })
    ]
    ++ lib.optionals (!ungoogled) [
      (fetchpatch {
        name = "chromium-146-revert-Add-finch-seeds-to-desktop-perf-builds.patch";
        url = "https://chromium.googlesource.com/chromium/src/+/d2e8a550eece6051372da94a475a8661da203106^!?format=TEXT";
        decode = "base64 -d";
        revert = true;
        hash = "sha256-tJ//HE7o9R8nSQDGhi+MKXdNUwnkCZI++CzpAmFn2YY=";
      })
    ]
    ++ lib.optionals (versionRange "146" "148" && lib.versionOlder llvmVersion "23") [
      (fetchpatch {
        name = "chromium-146-revert-Update-fsanitizer=array-bounds-config.patch";
        url = "https://chromium.googlesource.com/chromium/src/+/acb47d9a6b56c4889a2ed4216e9968cfc740086c^!?format=TEXT";
        decode = "base64 -d";
        revert = true;
        hash = "sha256-WZsN2qm6lX121bDf7SoN75flXtCTmPPpwtHK0ayjkPc=";
      })
    ]
    ++ lib.optionals (!versionRange "146" "147") [
      ./patches/chromium-142-bytemuck-rust-1.95.patch
    ]
    ++ lib.optionals (chromiumVersionAtLeast "147" && lib.versionOlder llvmVersion "23") [
      ./patches/chromium-147-llvm-22.patch
    ]
    ++ lib.optionals (versionRange "148" "149" && lib.versionOlder llvmVersion "23") [
      (fetchpatch {
        name = "chromium-148-revert-build-Add--fsanitizer=return-config.patch";
        url = "https://chromium.googlesource.com/chromium/src/+/99ba1f5302f9433efdb4df302cb7b7de56c72e4c^!?format=TEXT";
        decode = "base64 -d";
        revert = true;
        hash = "sha256-/qzzxwTdPMwIdsqD/G02S7kKHCj3QxECL+g1WYEaWmU=";
      })
      (fetchpatch {
        name = "chromium-148-revert-build-Enable--fsanitizer=return-config.patch";
        url = "https://chromium.googlesource.com/chromium/src/+/9357bfbea03753fe52264c9ec36abe74f48cfef5^!?format=TEXT";
        decode = "base64 -d";
        revert = true;
        hash = "sha256-14fTHNh3vGsf4KgeH8uLX+aK3lrjK0VKd1dfK1g7r0I=";
      })
      (fetchpatch {
        name = "archlinux-chromium-146-drop-unknown-clang-flag.patch";
        url = "https://gitlab.archlinux.org/archlinux/packaging/packages/chromium/-/raw/148.0.7778.96-1/chromium-146-drop-unknown-clang-flag.patch";
        hash = "sha256-jR0G9z2R8VGl2tkB3u0368RyWM1J6qYXqNWwKkYd5zU=";
      })
    ]
    ++ lib.optionals (versionRange "151" "153" && lib.versionOlder llvmVersion "23") [
      (fetchpatch {
        name = "chromium-151-revert-Fix-is_wasm-compile-for-supersize.patch";
        url = "https://chromium.googlesource.com/chromium/src/+/160ccfd3b5a2dbab95516928716ae586e17de84b^!?format=TEXT";
        decode = "base64 -d";
        revert = true;
        hash = "sha256-musbcTi2XMnJXW79gG+kr9qcYJZ25fv6MeIeId/nAwI=";
      })
    ]
    ++ lib.optionals (versionRange "149" "153" && lib.versionOlder llvmVersion "23") [
      ./patches/chromium-149-llvm-22.patch
    ]
    ++ lib.optionals (versionRange "153" "155" && lib.versionOlder llvmVersion "23") [
      ./patches/chromium-153-llvm-22.patch
    ]
    ++ lib.optionals (chromiumVersionAtLeast "155" && lib.versionOlder llvmVersion "23") [
      ./patches/chromium-155-llvm-22.patch
    ]
    ++ lib.optionals (chromiumVersionAtLeast "149" && llvmStdenv.hostPlatform.isAarch64) [
      ./patches/chromium-149-use-of-undeclared-identifier-ERROR.patch
    ]
    ++ lib.optionals (versionRange "148" "149") [
      (fetchpatch {
        name = "chromium-148-revert-Reland-build-use-tool-inputs-instead-of-siso-config-for-rust-actions.patch";
        url = "https://chromium.googlesource.com/chromium/src/+/9193ab90af24c23ee983e0a8da9bed45712f0d26^!?format=TEXT";
        decode = "base64 -d";
        revert = true;
        hash = "sha256-7xg8IZ2gO+Wtnv7lWLVE3lLpcmMgvtDtcWwUuMBzkrE=";
      })
    ]
    ++ lib.optionals (versionRange "150" "151") [
      (fetchpatch {
        name = "chromium-150-backport-build--Omit-ar-from-inputs-when-resolved-via--PATH.patch";
        url = "https://chromium.googlesource.com/chromium/src/+/60f987d8d5f7272793a40290d060b8f50933f825^!?format=TEXT";
        decode = "base64 -d";
        hash = "sha256-MryWxSwBxSIONhl3X1cDxTWwNWy8a4yt/sqkrueSUNs=";
      })
    ]
    ++ lib.optionals (versionRange "151" "152") [
      (fetchpatch {
        name = "chromium-151-backport-don't-depends-on-histograms.xml-if-it-is-not-git-checkout.patch";
        url = "https://chromium.googlesource.com/chromium/src/+/27f8690db999f6e56f0af7a9ea3d28a019ed72ca^!?format=TEXT";
        decode = "base64 -d";
        hash = "sha256-nKu1NEuBWYCmHC2P33BqULVU6uK//kBIEOx+fXIwsuQ=";
      })
    ]
    ++ lib.optionals (chromiumVersionAtLeast "151") [
      ./patches/chromium-151-dawn-use-Go-from-PATH.patch
    ]
    ++ lib.optionals (chromiumVersionAtLeast "151.0.7922.169" && !ungoogled) [
      (fetchpatch {
        name = "chromium-151-revert-Show-Linux-first-run-terms-of-service-dialog-by-default.patch";
        url = "https://chromium.googlesource.com/chromium/src/+/ae9b17ac975d4b10af762e9344083d858f1347ce^!?format=TEXT";
        decode = "base64 -d";
        revert = true;
        includes = [ "chrome/browser/first_run/first_run.h" ];
        hash = "sha256-d1Zm2flZPG++ROF4CCawn9U8T7/qgZFMHTXArqIShTk=";
      })
    ]
    ++ lib.optionals (versionRange "152" "155") [
      ./patches/ungoogled-chromium-152-crubit.patch
    ]
    ++ lib.optionals (versionRange "152" "153" && lib.versionOlder llvmVersion "23") [
      ./patches/chromium-152-dawn-llvm-22.patch
    ]
    ++ lib.optionals (chromiumVersionAtLeast "153") [
      (fetchpatch {
        name = "chromium-153-revert-DEPS-use-DEPS-provided-python-instead-of-a-system-one.patch";
        url = "https://chromium.googlesource.com/chromium/src/+/ce8851b40f37e74adcb7813256930792f35b8039^!?format=TEXT";
        decode = "base64 -d";
        revert = true;
        includes = [ ".gn" ];
        hash = "sha256-xrtu5YhxJtBFlKpQCqRR1BBkJyiN/DW+aUCVB1zZVHI=";
      })
    ]
    ++ lib.optionals (versionRange "153" "154") [
      (fetchpatch {
        name = "chromium-153-revert-Migrate-OpenType-format-check-bindings-to-Crubit.patch";
        url = "https://chromium.googlesource.com/chromium/src/+/493e6c3911e33cc356856bafbffc6cf95521266b^!?format=TEXT";
        decode = "base64 -d";
        revert = true;
        hash = "sha256-+5lddQSOJz7XTZanDl3/lqQ7CQhnCVzvUMpxvE3Sz2c=";
      })
    ]
    ++ lib.optionals (versionRange "153" "155") [
      (fetchpatch {
        name = "chromium-153-revert-devtools-frontend-Remove-TSGO-flag.patch";
        url = "https://chromium.googlesource.com/devtools/devtools-frontend/+/2691b4ae139d2e7b6244f05139a0b85082c7473c^!?format=TEXT";
        decode = "base64 -d";
        stripLen = 1;
        extraPrefix = "third_party/devtools-frontend/src/";
        revert = true;
        hash = "sha256-Dip5axpXSJbdGmtS7t81nLCvjRPBSkAuJA4Lo6MFKLw=";
      })
    ];

    postPatch =
      ''
        cp ${./files/gclient_args.gni} build/config/gclient_args.gni
        chmod u+w build/config/gclient_args.gni
        echo 'checkout_mutter = false' >> build/config/gclient_args.gni
        echo 'checkout_glic_e2e_tests = false' >> build/config/gclient_args.gni
        echo 'checkout_clusterfuzz_data = false' >> build/config/gclient_args.gni
      ''
      + ''

        echo 'LASTCHANGE=${upstream-info.DEPS."src".rev}-refs/tags/${upstream-info.version}@{#0}' > build/util/LASTCHANGE
        echo "$SOURCE_DATE_EPOCH" > build/util/LASTCHANGE.committime

        cat << EOF > gpu/config/gpu_lists_version.h
        /* Generated by lastchange.py, do not edit.*/
        #ifndef GPU_CONFIG_GPU_LISTS_VERSION_H_
        #define GPU_CONFIG_GPU_LISTS_VERSION_H_
        #define GPU_LISTS_VERSION "${upstream-info.DEPS."src".rev}"
        #endif  // GPU_CONFIG_GPU_LISTS_VERSION_H_
        EOF

        cat << EOF > skia/ext/skia_commit_hash.h
        /* Generated by lastchange.py, do not edit.*/
        #ifndef SKIA_EXT_SKIA_COMMIT_HASH_H_
        #define SKIA_EXT_SKIA_COMMIT_HASH_H_
        #define SKIA_COMMIT_HASH "${upstream-info.DEPS."src/third_party/skia".rev}"
        #endif  // SKIA_EXT_SKIA_COMMIT_HASH_H_
        EOF

        echo -n '${upstream-info.DEPS."src/third_party/dawn".rev}' > gpu/webgpu/DAWN_VERSION

        mkdir -p third_party/jdk/current/bin
      ''
      + ''
        cat << EOF > gpu/webgpu/dawn_commit_hash.h
        /* Generated by lastchange.py, do not edit.*/
        #ifndef GPU_WEBGPU_DAWN_COMMIT_HASH_H_
        #define GPU_WEBGPU_DAWN_COMMIT_HASH_H_
        #define DAWN_COMMIT_HASH "${upstream-info.DEPS."src/third_party/dawn".rev}"
        #endif  // GPU_WEBGPU_DAWN_COMMIT_HASH_H_
        EOF
      ''
      + ''
        substituteInPlace BUILD.gn \
          --replace '"//infra/orchestrator:orchestrator_all",' ""
        substituteInPlace build/config/compiler/BUILD.gn \
          --replace '"-Xclang",' "" \
          --replace '"-no-opaque-pointers",' ""
        for lib in ${toString gnSystemLibraries}; do
          if [ -d "third_party/$lib" ]; then
            find "third_party/$lib" -type f \
              \! -path "third_party/$lib/chromium/*" \
              \! -path "third_party/$lib/google/*" \
              \! -path "third_party/harfbuzz-ng/utils/hb_scoped.h" \
              \! -regex '.*\.\(gn\|gni\|isolate\)' \
              -delete
          fi
        done

        if [[ -e native_client/SConstruct ]]; then
          substituteInPlace native_client/SConstruct --replace "#! -*- python -*-" ""
        fi
        if [ -e third_party/harfbuzz-ng/src/src/update-unicode-tables.make ]; then
          substituteInPlace third_party/harfbuzz-ng/src/src/update-unicode-tables.make \
            --replace "/usr/bin/env -S make -f" "/usr/bin/make -f"
        fi
        if [ -e third_party/webgpu-cts/src/tools/run_deno ]; then
          chmod -x third_party/webgpu-cts/src/tools/run_deno
        fi
        if [ -e third_party/dawn/third_party/webgpu-cts/tools/run_deno ]; then
          chmod -x third_party/dawn/third_party/webgpu-cts/tools/run_deno
        fi

        substituteInPlace sandbox/linux/suid/client/setuid_sandbox_host.cc \
          --replace \
            'return sandbox_binary;' \
            'return base::FilePath(GetDevelSandboxPath());'

        substituteInPlace services/audio/audio_sandbox_hook_linux.cc \
          --replace \
            '/usr/share/alsa/' \
            '${alsa-lib}/share/alsa/' \
          --replace \
            '/usr/lib/x86_64-linux-gnu/gconv/' \
            '${glibc}/lib/gconv/' \
          --replace \
            '/usr/share/locale/' \
            '${glibc}/share/locale/'

      ''
      + ''
        sed -i -e 's,/usr,/run/current-system/sw,' chrome/common/chrome_paths.cc

        find . -type f -perm -0100 -exec sed -i -e '$a\' {} +

        patchShebangs .
      ''
      + lib.optionalString ungoogled ''
        ${ungoogler}/utils/prune_binaries.py . ${ungoogler}/pruning.list || echo "some errors"
      ''
      + ''
        mkdir -p third_party/node/linux/node-linux-x64/bin${lib.optionalString ungoogled " third_party/jdk/current/bin/"}
        ln -sf "${pkgsBuildHost.nodejs}/bin/node" third_party/node/linux/node-linux-x64/bin/node
        ln -s "${pkgsBuildHost.java}/bin/java" third_party/jdk/current/bin/

        sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' tools/generate_shim_headers/generate_shim_headers.py

      ''
      + lib.optionalString (chromiumVersionAtLeast "148") ''
        mkdir -p third_party/gperf/cipd/bin
        ln -s "${pkgsBuildHost.gperf}/bin/gperf" third_party/gperf/cipd/bin/gperf
      ''
      + lib.optionalString (chromiumVersionAtLeast "149") ''
        mkdir -p third_party/rust-toolchain/bin
        ln -s "${buildPackages.rustc}/bin/rustc" third_party/rust-toolchain/bin/rustc
      ''
      + lib.optionalString (chromiumVersionAtLeast "154") ''
        mkdir -p third_party/typescript/linux-amd64/src
        ${
          if chromiumVersionAtLeast "155" then "cp -rv" else "ln -sv"
        } ${buildPackages.typescript}/lib/typescript third_party/typescript/linux-amd64/src/lib
      ''
      + lib.optionalString (chromiumVersionAtLeast "155") ''
        chmod u+w -R third_party/typescript/linux-amd64/src/lib
        patch --strip=1 --directory=third_party/typescript/linux-amd64/src --input=../3pp/patches/typescript_native_preview.patch
      ''
      + lib.optionalString (chromiumVersionAtLeast "154") ''

        mkdir -p third_party/devtools-frontend/src/third_party/esbuild
        ln -sv ${esbuild}/bin/esbuild third_party/devtools-frontend/src/third_party/esbuild/esbuild

        mkdir -p buildtools/linux64-format
        ln -sv ${buildPackages.rustc.llvmPackages.clang-tools}/bin/clang-format buildtools/linux64-format/clang-format

        ln -sv ${buildPackages.cargo}/bin/cargo third_party/rust-toolchain/bin/cargo
        ln -sv ${buildPackages.rustfmt}/bin/rustfmt third_party/rust-toolchain/bin/rustfmt
        ln -sv ${crubit}/bin/* third_party/rust-toolchain/bin/

        mkdir -p third_party/rust-toolchain/lib/third_party
        ln -sv ${crubit.src} third_party/rust-toolchain/lib/third_party/crubit

        mkdir -p third_party/rust-toolchain/lib/rustlib/src/rust
        cp -r ${rustPlatform.rustcSrc}/. third_party/rust-toolchain/lib/rustlib/src/rust/
        chmod u+w -R third_party/rust-toolchain/lib/rustlib
        ln -sv ${rustPlatform.rustVendorSrc} third_party/rust-toolchain/lib/rustlib/src/rust/library/vendor

        ${lib.getExe buildPackages.rustc} -V > third_party/rust-toolchain/VERSION
      ''
      +
        lib.optionalString (llvmStdenv.hostPlatform == llvmStdenv.buildPlatform && llvmStdenv.hostPlatform.isAarch64)
          ''
            substituteInPlace build/toolchain/linux/BUILD.gn \
              --replace 'toolprefix = "aarch64-linux-gnu-"' 'toolprefix = ""'
          ''
      + lib.optionalString ungoogled ''
        ${ungoogler}/utils/patches.py . ${ungoogler}/patches
        ${ungoogler}/utils/domain_substitution.py apply -r ${ungoogler}/domain_regex.list -f ${ungoogler}/domain_substitution.list -c ./ungoogled-domsubcache.tar.gz .
      '';

    hardeningDisable = [ "strictflexarrays1" ];

    preConfigure =
      ''
        (
          cd third_party/node
          grep patch update_npm_deps | sh
        )
      ''
      + ''
        rm -r third_party/node/node_modules/@lit/reactive-element/development
      ''
      + lib.optionalString (chromiumVersionAtLeast "148") ''
        rm -r third_party/node/node_modules/@types/estree
      ''
      + lib.optionalString (chromiumVersionAtLeast "154") ''
        ${lib.getExe gnrt} gen --for-std "third_party/rust-toolchain/lib/rustlib/src/rust"
      '';

    configurePhase = ''
      runHook preConfigure

      libExecPath="${libExecPath}"
      ${python3.pythonOnBuildForHost}/bin/python3 build/linux/unbundle/replace_gn_files.py --system-libraries ${toString gnSystemLibraries}
      gn gen --args=${lib.escapeShellArg gnFlags} out/Release | tee gn-gen-outputs.txt

      grep -o WARNING gn-gen-outputs.txt && echo "Found gn WARNING, exiting nix build" && exit 1

      runHook postConfigure
    '';

    env = {
      RUSTC_BOOTSTRAP = 1;

      NIX_CFLAGS_COMPILE =
        "-Wno-unknown-warning-option -Wno-unused-command-line-argument -Wno-shadow"
        + lib.optionalString (chromiumVersionAtLeast "149") " -Wno-macro-redefined";

      BUILD_CC = "$CC_FOR_BUILD";
      BUILD_CXX = "$CXX_FOR_BUILD";
      BUILD_AR = "$AR_FOR_BUILD";
      BUILD_NM = "$NM_FOR_BUILD";
      BUILD_READELF = "$READELF_FOR_BUILD";
    }
    // lib.optionalAttrs (chromiumVersionAtLeast "150") {
      NIX_LD_USE_RESPONSE_FILE = 1;
    };

    buildPhase = ''
      runHook preBuild
      TERM=dumb ninja -C "${buildPath}" -j$NIX_BUILD_CORES "chrome_sandbox"
      TERM=dumb ninja -C "${buildPath}" -j$NIX_BUILD_CORES "chrome"
      bash -s << EOL
      (
        source remoting/host/installer/linux//installer.include
        PACKAGE=$packageName
        MENUNAME="Chromium"
        process_template chrome/app/resources/manpage.1.in "${buildPath}/chrome.1"
      )
      EOL
      runHook postBuild
    '';

    outputs = [
      "out"
      "sandbox"
    ];

    installPhase = ''
      mkdir -p "$libExecPath"
      cp -v "$buildPath/"*.so "$buildPath/"*.pak "$buildPath/"*.bin "$libExecPath/"
      cp -v "$buildPath/libvulkan.so.1" "$libExecPath/"
      cp -v "$buildPath/vk_swiftshader_icd.json" "$libExecPath/"
      cp -v "$buildPath/icudtl.dat" "$libExecPath/"
      cp -vLR "$buildPath/locales" "$buildPath/resources" "$libExecPath/"
      cp -v "$buildPath/chrome_crashpad_handler" "$libExecPath/"
      cp -v "$buildPath/chrome" "$libExecPath/$packageName"

      if [ -n "$(find "$buildPath/swiftshader/" -maxdepth 1 -name '*.so' -print -quit)" ]; then
        echo "Swiftshader files found; installing"
        mkdir -p "$libExecPath/swiftshader"
        cp -v "$buildPath/swiftshader/"*.so "$libExecPath/swiftshader/"
      else
        echo "Swiftshader files not found"
      fi

      mkdir -p "$sandbox/bin"
      cp -v "$buildPath/chrome_sandbox" "$sandbox/bin/${sandboxExecutableName}"

      mkdir -vp "$out/share/man/man1"
      cp -v "$buildPath/chrome.1" "$out/share/man/man1/$packageName.1"

      for icon_file in chrome/app/theme/chromium/product_logo_*[0-9].png; do
        num_and_suffix="''${icon_file##*logo_}"
        icon_size="''${num_and_suffix%.*}"
        expr "$icon_size" : "^[0-9][0-9]*$" || continue
        logo_output_prefix="$out/share/icons/hicolor"
        logo_output_path="$logo_output_prefix/''${icon_size}x''${icon_size}/apps"
        mkdir -vp "$logo_output_path"
        cp -v "$icon_file" "$logo_output_path/$packageName.png"
      done

      install -D chrome/installer/linux/common/desktop.template \
        $out/share/applications/chromium-browser.desktop

      substituteInPlace $out/share/applications/chromium-browser.desktop \
        --replace-fail "@@MENUNAME" "Chromium" \
        --replace-fail "${
          if chromiumVersionAtLeast "154" then "@@desktop_icon" else "@@PACKAGE"
        }" "chromium" \
        --replace-fail "${
          if chromiumVersionAtLeast "154" then "@@desktop_exec" else "/usr/bin/@@usr_bin_symlink_name"
        }" "chromium" \
        --replace-fail "@@uri_scheme" "x-scheme-handler/chromium;" \
        --replace-fail "@@startup_wm_class" "chromium-browser" \
        --replace-fail "@@extra_desktop_entries" ""

      if grep -F '@@' $out/share/applications/chromium-browser.desktop ; then
        echo "error: chromium-browser.desktop contains unsubstituted placeholders" >&2
        exit 1
      fi
    '';

    postFixup = ''
      for chromiumBinary in "$libExecPath/$packageName" "$libExecPath/libGLESv2.so"; do
        patchelf --set-rpath "${
          lib.makeLibraryPath [
            libGL
            vulkan-loader
            pciutils
          ]
        }:$(patchelf --print-rpath "$chromiumBinary")" "$chromiumBinary"
      done

      rm "$libExecPath/libvulkan.so.1"
      ln -s -t "$libExecPath" "${lib.getLib vulkan-loader}/lib/libvulkan.so.1"
    '';

    passthru = {
      inherit sandboxExecutableName;
      inherit chromiumDeps;
    };

    requiredSystemFeatures = [ "big-parallel" ];

    meta = {
      description =
        "Open source web browser from Google"
        + lib.optionalString ungoogled ", with dependencies on Google web services removed";
      longDescription = ''
        Chromium is an open source web browser from Google that aims to build a
        safer, faster, and more stable way for all Internet users to experience
        the web. It has a minimalist user interface and provides the vast majority
        of source code for Google Chrome (which has some additional features).
      '';
      homepage =
        if ungoogled then
          "https://github.com/ungoogled-software/ungoogled-chromium"
        else
          "https://www.chromium.org/";
      license = if enableWideVine then lib.licenses.unfree else lib.licenses.bsd3;
      platforms = lib.platforms.linux;
      mainProgram = "chromium";
      timeout = 172800; # 48 hours
    };
  };

in

# ---- Outer wrapper derivation ----
# This creates the final chromium binary with all runtime paths set up.
llvmStdenv.mkDerivation {
  pname = lib.optionalString ungoogled "ungoogled-" + "chromium";
  inherit (browser) version;

  nativeBuildInputs = [
    makeWrapper
    ed
  ];

  buildInputs = [
    gsettings-desktop-schemas
    glib
    gtk3
    gtk4

    adwaita-icon-theme

    libkrb5
  ];

  outputs = [
    "out"
    "sandbox"
  ];

  buildCommand =
    let
      browserBinary = "${browser}/libexec/chromium/chromium";
      libPath = lib.makeLibraryPath [
        libva
        pipewire
        wayland
        gtk3
        gtk4
        libkrb5
      ];

    in
    ''
      mkdir -p "$out/bin"

      makeWrapper "${browserBinary}" "$out/bin/chromium" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --add-flags ${lib.escapeShellArg commandLineArgs}

      ed -v -s "$out/bin/chromium" << EOF
      2i

      if [ -x "/run/wrappers/bin/${sandboxExecutableName}" ]
      then
        export CHROME_DEVEL_SANDBOX="/run/wrappers/bin/${sandboxExecutableName}"
      else
        export CHROME_DEVEL_SANDBOX="$sandbox/bin/${sandboxExecutableName}"
      fi

      export CHROME_WRAPPER='chromium'

    ''
    + lib.optionalString (libPath != "") ''
      export LD_LIBRARY_PATH="\$LD_LIBRARY_PATH\''${LD_LIBRARY_PATH:+:}${libPath}"
    ''
    + ''

      export LD_PRELOAD="\$(echo -n "\$LD_PRELOAD" | ${coreutils}/bin/tr ':' '\n' | ${grep}/bin/grep -v /lib/libredirect\\\\.so$ | ${coreutils}/bin/tr '\n' ':')"

      export XDG_DATA_DIRS=$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH\''${XDG_DATA_DIRS:+:}\$XDG_DATA_DIRS

    ''
    + lib.optionalString (!xdg-utils.meta.broken) ''
      export PATH="\$PATH\''${PATH:+:}${xdg-utils}/bin"
    ''
    + ''

      .
      w
      EOF

      ln -sv "${browser.sandbox}" "$sandbox"

      ln -s "$out/bin/chromium" "$out/bin/chromium-browser"

      mkdir -p "$out/share"
      for f in '${browser}'/share/*; do
        ln -s -t "$out/share/" "$f"
      done
    '';

  inherit (browser) packageName;
  meta = browser.meta;
  passthru = {
    inherit browser upstream-info;
    inherit sandboxExecutableName;
  };
}
