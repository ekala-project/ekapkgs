{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,

  asciidoctor,
  botan3,
  keyutils,
  libusb1,
  libx11,
  minizip,
  pcsclite,
  pkg-config,
  qrencode,
  readline,
  gtk3,
  zlib,

  withKeePassBrowser ? true,
  withKeePassBrowserPasskeys ? true,
  withKeePassFDOSecrets ? true,
  withKeePassKeeShare ? true,
  withKeePassNetworking ? true,
  withKeePassSSHAgent ? true,
  withKeePassX11 ? true,
  withKeePassYubiKey ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keepassxc";
  version = "2.8.0-beta1";

  src = fetchFromGitHub {
    owner = "keepassxreboot";
    repo = "keepassxc";
    tag = finalAttrs.version;
    hash = "sha256-fksThYmGZed66zxGDxlS2SHQzJYRf+T9AuZPbaNZV5Y=";
  };

  # Create a shim for ints.h which minizip's ioapi.h references but
  # the ekapkgs minizip package doesn't install.
  preConfigure = ''
    mkdir -p $TMPDIR/minizip-ints-shim
    cat > $TMPDIR/minizip-ints-shim/ints.h << 'INTS_H'
    /* shim: redirect to standard integer types */
    #ifndef MINIZIP_INTS_H_SHIM
    #define MINIZIP_INTS_H_SHIM
    #include <stdint.h>
    typedef int8_t i8_t;
    typedef uint8_t ui8_t;
    typedef int16_t i16_t;
    typedef uint16_t ui16_t;
    typedef int32_t i32_t;
    typedef uint32_t ui32_t;
    typedef int64_t i64_t;
    typedef uint64_t ui64_t;
    #endif
    INTS_H
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$TMPDIR/minizip-ints-shim"
  '';

  cmakeEntries = {
    KEEPASSXC_BUILD_TYPE = "Release";
    WITH_GUI_TESTS = true;
    WITH_XC_UPDATECHECK = false;
    WITH_XC_X11 = withKeePassX11;
    WITH_XC_BROWSER = withKeePassBrowser;
    WITH_XC_BROWSER_PASSKEYS = withKeePassBrowserPasskeys;
    WITH_XC_KEESHARE = withKeePassKeeShare;
    WITH_XC_NETWORKING = withKeePassNetworking;
    WITH_XC_SSHAGENT = withKeePassSSHAgent;
    WITH_XC_FDOSECRETS = withKeePassFDOSecrets;
    WITH_XC_YUBIKEY = withKeePassYubiKey;
  };

  # Tests segfault due to duktape/glibc IFUNC incompatibility in the build environment
  doCheck = false;

  nativeBuildInputs = [
    asciidoctor
    cmake
    cmake.configurePhaseHook
    qt6.wrapQtAppsHook
    (qt6.qttools.override { qtdeclarative = null; })
    pkg-config
    gtk3.wrapGAppsHook
  ];

  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall = lib.optionalString withKeePassBrowser ''
    mkdir -p "$out/lib/mozilla/native-messaging-hosts"
    substituteAll "${./firefox-native-messaging-host.json}" "$out/lib/mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json"

    mkdir -p "$out/etc/chromium/native-messaging-hosts"
    substituteAll "${./chromium-native-messaging-host.json}" "$out/etc/chromium/native-messaging-hosts/org.keepassxc.keepassxc_browser.json"
  '';

  buildInputs = [
    botan3
    keyutils
    libusb1
    libx11
    minizip
    pcsclite
    qrencode
    qt6.qtbase
    qt6.qtsvg
    readline
    zlib
  ];

  meta = {
    description = "Offline password manager with many features";
    longDescription = ''
      A community fork of KeePassX, which is itself a port of KeePass Password Safe.
      The goal is to extend and improve KeePassX with new features and bugfixes,
      to provide a feature-rich, fully cross-platform and modern open-source password manager.
      Accessible via native cross-platform GUI, CLI, has browser integration
      using the KeePassXC Browser Extension (https://github.com/keepassxreboot/keepassxc-browser)
    '';
    homepage = "https://keepassxc.org/";
    changelog = "https://github.com/keepassxreboot/keepassxc/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    mainProgram = "keepassxc";
    platforms = lib.platforms.linux;
  };
})
