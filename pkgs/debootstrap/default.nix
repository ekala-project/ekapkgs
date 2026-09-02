{
  lib,
  stdenv,
  fetchFromGitLab,
  dpkg,
  gawk,
  perl,
  wget,
  binutils,
  bzip2,
  coreutils,
  util-linux,
  gnugrep,
  gnupg,
  gnutar,
  gnused,
  gzip,
  xz,
  zstd,
  makeWrapper,
}:

let
  binPath = lib.makeBinPath [
    binutils
    bzip2
    coreutils
    dpkg
    gawk
    gnugrep
    gnupg
    gnused
    gnutar
    gzip
    perl
    util-linux
    wget
    xz
    zstd
  ];
in
stdenv.mkDerivation rec {
  pname = "debootstrap";
  version = "1.0.140_bpo12+1";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "installer-team";
    repo = "debootstrap";
    rev = "refs/tags/${version}";
    hash = "sha256-4vINaMRo6IrZ6e2/DAJ06ODy2BWm4COR1JDSY52upUc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    substituteInPlace debootstrap \
      --replace 'CHROOT_CMD="chroot '  'CHROOT_CMD="${coreutils}/bin/chroot ' \
      --replace 'CHROOT_CMD="unshare ' 'CHROOT_CMD="${util-linux}/bin/unshare ' \
      --replace /usr/bin/dpkg ${dpkg}/bin/dpkg \
      --replace '#!/bin/sh' '#!/bin/bash' \
      --subst-var-by VERSION ${version}

    d=$out/share/debootstrap
    mkdir -p $out/{share/debootstrap,bin}

    mv debootstrap $out/bin

    cp -r . $d

    wrapProgram $out/bin/debootstrap \
      --set PATH ${binPath} \
      --set-default DEBOOTSTRAP_DIR $d

    mkdir -p $out/man/man8
    mv debootstrap.8 $out/man/man8

    rm -rf $d/debian

    runHook postInstall
  '';

  meta = {
    changelog = "https://salsa.debian.org/installer-team/debootstrap/-/blob/${version}/debian/changelog";
    description = "Tool to create a Debian system in a chroot";
    homepage = "https://wiki.debian.org/Debootstrap";
    license = lib.licenses.mit;
    mainProgram = "debootstrap";
    platforms = lib.platforms.linux;
  };
}
