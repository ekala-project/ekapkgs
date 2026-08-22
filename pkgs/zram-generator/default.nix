{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  bash,
  ronn ? null,
  systemd,
  kmod,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zram-generator";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "zram-generator";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aGBvvjGKZ5biruwmJ0ITakqPhTWs9hspRIE9QirqstA=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
    substituteInPlace Makefile \
      --replace-fail 'target/$(BUILDTYPE)' 'target/${stdenv.hostPlatform.rust.rustcTargetSpec}/$(BUILDTYPE)'
    substituteInPlace src/generator.rs \
      --replace-fail 'Command::new("systemd-detect-virt")' 'Command::new("${systemd}/bin/systemd-detect-virt")' \
      --replace-fail 'Command::new("modprobe")' 'Command::new("${kmod}/bin/modprobe")'
    substituteInPlace src/config.rs \
      --replace-fail 'Command::new("/bin/sh")' 'Command::new("${bash}/bin/sh")'
  '';

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optional (ronn != null) ronn;

  buildInputs = [
    systemd
  ];

  preBuild = ''
    export SYSTEMD_UTIL_DIR=$($PKG_CONFIG --variable=systemdutildir systemd)
  '';

  doCheck = false;

  dontCargoInstall = true;

  installFlags = [
    "-o program"
    "PREFIX=$(out)"
    "SYSTEMD_SYSTEM_UNIT_DIR=$(out)/lib/systemd/system"
    "SYSTEMD_SYSTEM_GENERATOR_DIR=$(out)/lib/systemd/system-generators"
  ]
  ++ lib.optional (ronn == null) "NOMAN=1";

  makeFlags = lib.optional (ronn == null) "NOMAN=1";

  meta = {
    homepage = "https://github.com/systemd/zram-generator";
    license = lib.licenses.mit;
    description = "Systemd unit generator for zram devices";
    maintainers = [ ];
  };
})
