{
  lib,
  check,
  cmake,
  fetchFromGitHub,
  gengetopt,
  help2man,
  openssl,
  pcsclite,
  pkg-config,
  stdenv,
  testers,
  zlib,
  withApplePCSC ? stdenv.hostPlatform.isDarwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yubico-piv-tool";
  version = "2.7.3";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubico-piv-tool";
    tag = "yubico-piv-tool-${finalAttrs.version}";
    hash = "sha256-BXYsx9GtH3svHTnJuqCiWIJ+9kE09BjAPbAPKawNCDc=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail "-Werror" ""
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    gengetopt
    help2man
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
  ]
  ++ lib.optionals (!withApplePCSC) [ pcsclite ];

  cmakeEntries = {
    GENERATE_MAN_PAGES = true;
    BACKEND = (if withApplePCSC then "macscard" else "pcsc");
    CMAKE_INSTALL_BINDIR = "bin";
    CMAKE_INSTALL_INCLUDEDIR = "include";
    CMAKE_INSTALL_LIBDIR = "lib";
    CMAKE_INSTALL_MANDIR = "share/man";
  };

  doCheck = true;

  nativeCheckInputs = [ check ];

  passthru = {
    tests = {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "yubico-piv-tool --version";
      };
    };
  };

  meta = {
    homepage = "https://developers.yubico.com/yubico-piv-tool/";
    changelog = "https://developers.yubico.com/yubico-piv-tool/Release_Notes.html";
    description = ''
      Used for interacting with the Privilege and Identification Card (PIV)
      application on a YubiKey
    '';
    longDescription = ''
      The Yubico PIV tool is used for interacting with the Privilege and
      Identification Card (PIV) application on a YubiKey.
      With it you may generate keys on the device, importing keys and
      certificates, and create certificate requests, and other operations.
      A shared library and a command-line tool is included.
    '';
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    mainProgram = "yubico-piv-tool";
    pkgConfigModules = [
      "ykcs11"
      "ykpiv"
    ];
  };
})
