{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  pkg-config,
  cmake,
  ninja,
  python3,
  qt6,
  tdlib,
  tg_owt,
  lz4,
  xxhash,
  ffmpeg,
  protobuf,
  openal-soft,
  minizip-ng-compat,
  range-v3,
  tl-expected,
  hunspell,
  gobject-introspection,
  rnnoise,
  microsoft-gsl,
  boost,
  ada,
  cmark-gfm,
  gtk3,
  glib-networking,
}:
let
  unwrapped = stdenv.mkDerivation (finalAttrs: {
    pname = "telegram-desktop-unwrapped";
    version = "7.0.2";

    src = fetchFromGitHub {
      owner = "telegramdesktop";
      repo = "tdesktop";
      rev = "v${finalAttrs.version}";
      fetchSubmodules = true;
      hash = "sha256-G/A5J2m1sXHD50zDmMD9ehnorAGRjnQ+YGMv6DEiJcQ=";
    };

    nativeBuildInputs = [
      pkg-config
      cmake
      cmake.configurePhaseHook
      ninja
      python3
      qt6.qtshadertools
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      gobject-introspection
    ];

    buildInputs = [
      qt6.qtbase
      qt6.qtsvg
      lz4
      xxhash
      ffmpeg.v6
      openal-soft
      minizip-ng-compat
      range-v3
      tl-expected
      rnnoise
      tg_owt
      microsoft-gsl
      boost
      ada
      cmark-gfm
      (tdlib.override { tde2eOnly = true; })
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      protobuf
      qt6.qtwayland
      hunspell
    ];

    dontWrapQtApps = true;

    cmakeFlags = [
      # We're allowed to used the API ID of the Snap package:
      (lib.cmakeFeature "TDESKTOP_API_ID" "611335")
      (lib.cmakeFeature "TDESKTOP_API_HASH" "d524b414d21f4d37f08684c1df41ac9c")
      # swift 6 is not available
      (lib.cmakeBool "DESKTOP_APP_DISABLE_SWIFT6" true)
    ];

    meta = {
      description = "Telegram Desktop messaging app";
      longDescription = ''
        Desktop client for the Telegram messenger, based on the Telegram API and
        the MTProto secure protocol.
      '';
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux;
      homepage = "https://desktop.telegram.org/";
      changelog = "https://github.com/telegramdesktop/tdesktop/releases/tag/v${finalAttrs.version}";
      mainProgram = "telegram-desktop";
    };
  });
in
stdenv.mkDerivation {
  pname = "telegram-desktop";
  inherit (unwrapped) version meta;

  inherit unwrapped;

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtimageformats
    qt6.qtsvg
    qt6.qtwayland
    glib-networking
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    cp -r "$unwrapped" "$out"
    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/share/dbus-1/services/* \
      --replace-fail "$unwrapped" "$out"
  '';
}
