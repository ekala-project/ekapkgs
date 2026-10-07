{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  replaceVars,

  # build system
  autoconf,
  automake,
  cmake,
  libtool,
  makeWrapper,
  pkg-config,
  ronn,
  which,

  # dependencies
  alsa-plugins,
  asyncSupport ? true,
  klattSupport ? true,
  mbrola ? null,
  mbrolaSupport ? false,
  pcaudiolib,
  pcaudiolibSupport ? true,
  sonic ? null,
  sonicSupport ? false,
  speechPlayerSupport ? true,
  ucdSupport ? false,
}:

let
  version = "1.52.0.1-unstable-2025-09-09";

  src = fetchFromGitHub {
    owner = "espeak-ng";
    repo = "espeak-ng";
    rev = "0d451f8c1c6ae837418b823bd9c4cbc574ea9ff5";
    hash = "sha256-wpPi+YjSLhsEWfE3KEbL4A7o48qtz9fLRZ/u4xGOM2g=";
  };

  ucd-tools = stdenv.mkDerivation {
    pname = "ucd-tools";
    inherit version src;

    sourceRoot = "${src.name}/src/ucd-tools";

    # fix compatibility with CMake (https://cmake.org/cmake/help/v4.0/policy/CMP0000.html)
    postPatch = ''
      echo 'cmake_minimum_required(VERSION 4.0)' >> CMakeLists.txt
    '';

    nativeBuildInputs = [
      cmake
      cmake.configurePhaseHook
    ];

    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -v libucd.a $out/
      runHook postInstall
    '';
  };
in

stdenv.mkDerivation rec {
  pname = "espeak-ng";
  inherit version src;

  patches = [
    # https://github.com/espeak-ng/espeak-ng/pull/2274
    (fetchpatch {
      name = "libsonic.patch";
      url = "https://github.com/espeak-ng/espeak-ng/commit/83e646e711af608fafa8c01dd812cd29e073f644.patch";
      hash = "sha256-UHuURyqRy/JVYYJH5EI5J2cpBfCNeTE24sMmheb+D2Q=";
    })
    # Remove after next release.
    (fetchpatch {
      name = "cmake-default-ESPEAK_COMPAT-to-ON.patch";
      url = "https://github.com/espeak-ng/espeak-ng/commit/3dcbe7ea3ea85a9212968d0f05172dde4259e770.patch";
      hash = "sha256-U694hGe+cwy7qLe/6XmNHYIhccJGsbM0CzPZT5pIpUI=";
    })
  ]
  ++ lib.optionals mbrolaSupport [
    # Hardcode correct mbrola paths.
    (replaceVars ./mbrola.patch {
      inherit mbrola;
    })
  ];

  postPatch = lib.optionalString ucdSupport ''
    ln -s ${ucd-tools}/libucd.a src/ucd-tools/libucd.a
  '';

  nativeBuildInputs = [
    autoconf
    automake
    cmake
    cmake.configurePhaseHook
    libtool
    pkg-config
    ronn
    makeWrapper
    which
  ];

  buildInputs =
    lib.optional mbrolaSupport mbrola
    ++ lib.optional pcaudiolibSupport pcaudiolib
    ++ lib.optional sonicSupport sonic;

  cmakeEntries = {
    BUILD_SHARED_LIBS = true;
    USE_ASYNC = asyncSupport;
    USE_KLATT = klattSupport;
    USE_LIBPCAUDIO = pcaudiolibSupport;
    USE_LIBSONIC = sonicSupport;
    USE_MBROLA = mbrolaSupport;
    USE_SPEECHPLAYER = speechPlayerSupport;
  };

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/espeak-ng \
      --set ALSA_PLUGIN_DIR ${alsa-plugins}/lib/alsa-lib
  '';

  passthru = {
    inherit mbrolaSupport ucd-tools;
  };

  meta = {
    description = "Speech synthesizer that supports more than hundred languages and accents";
    homepage = "https://github.com/espeak-ng/espeak-ng";
    changelog = "https://github.com/espeak-ng/espeak-ng/blob/${src.rev}/ChangeLog.md";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    mainProgram = "espeak-ng";
  };
}
