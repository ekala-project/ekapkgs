{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  libuuid,
  libsodium,
  libunwind,
  keyutils,
  kmod,
  liburcu,
  zlib,
  libaio,
  zstd,
  lz4,
  attr,
  udev,
  fuse3 ? null,
  cargo,
  rustc,
  rustPlatform,
  rust-bindgen,
  makeWrapper,
  installShellFiles,
  fuseSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bcachefs-tools";
  version = "1.38.8";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9sDE7ua3WMCfV9ZbwQdAbpatv2IhvcwHzzPr+/l2au0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-F1+FeAlYSqOxeWJI8vHShpXrOZqYXjNGvty/s6f6u8w=";
  };

  patches = [
    (fetchpatch {
      name = "0001-bcachefs-tools-debug-copy-packed-bkey-fields-before-asserting.patch";
      url = "https://evilpiepirate.org/git/bcachefs-tools.git/patch/?id=79f119c4cd6900ab9ea27b0aa671f68300d9d38e";
      hash = "sha256-ACrpad93wrZOXhc73otnXBNQvyoDeZSfgtwze5nKaUE=";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "target/release/bcachefs" "target/${stdenv.hostPlatform.rust.rustcTargetSpec}/release/bcachefs"

    substituteInPlace src/commands/mount.rs \
      --replace-fail 'std::process::Command::new("modprobe")' 'std::process::Command::new("${lib.getExe' kmod "modprobe"}")'
  '';

  nativeBuildInputs = [
    pkg-config
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    rust-bindgen
    makeWrapper
    installShellFiles
  ];

  buildInputs = [
    libaio
    keyutils
    lz4
    libsodium
    libunwind
    liburcu
    libuuid
    zstd
    zlib
    attr
    udev
  ]
  ++ lib.optional fuseSupport fuse3;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "VERSION=${finalAttrs.version}"
    "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
    "DKMSDIR=${placeholder "dkms"}"
    "PKGCONFIG_SERVICEDIR=$(out)/lib/systemd/system"
    "PKGCONFIG_UDEVDIR=$(out)/lib/udev"
  ]
  ++ lib.optional fuseSupport "BCACHEFS_FUSE=1";

  enableParallelBuilding = true;

  installFlags = [
    "install"
    "install_dkms"
  ];

  env = {
    CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;
    "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_LINKER" = "${stdenv.cc.targetPrefix}cc";
  };

  doCheck = false;

  preCheck = lib.optionalString (!fuseSupport) ''
    rm tests/test_fuse.py
  '';
  checkFlags = [ "BCACHEFS_TEST_USE_VALGRIND=no" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd bcachefs \
      --bash <($out/sbin/bcachefs completions bash) \
      --zsh  <($out/sbin/bcachefs completions zsh) \
      --fish <($out/sbin/bcachefs completions fish)
  '';

  outputs = [
    "out"
    "dkms"
  ];

  passthru = {
    kernelModule = import ./kernel-module.nix finalAttrs.finalPackage;
  };

  meta = {
    description = "Tool for managing bcachefs filesystems";
    homepage = "https://bcachefs.org/";
    downloadPage = "https://github.com/koverstreet/bcachefs-tools";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "bcachefs";
  };
})
