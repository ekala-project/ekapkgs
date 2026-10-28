{
  lib,
  stdenv,
  fetchurl,
  writeText,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  kcoreaddons,
  ki18n,
  kwidgetsaddons,
  polkit-qt-1,
  cryptsetup,
  lvm2,
  mdadm,
  smartmontools,
  systemdMinimal,
  util-linux,
  bcachefs-tools,
  btrfs-progs,
  dosfstools,
  e2fsprogs,
  exfatprogs,
  f2fs-tools,
  fatresize,
  jfsutils,
  nilfs-utils,
  ntfs3g,
  udftools,
  xfsprogs,
  zfs ? null, # TODO: not yet in ekapkgs
}:

let
  # https://github.com/KDE/kpmcore/blob/v25.12.1/src/util/externalcommand_whitelist.h
  runtimeDeps = [
    cryptsetup
    lvm2
    mdadm
    smartmontools
    systemdMinimal
    util-linux

    bcachefs-tools
    btrfs-progs
    dosfstools
    e2fsprogs
    exfatprogs
    f2fs-tools
    fatresize
    jfsutils
    nilfs-utils
    ntfs3g
    udftools
    xfsprogs
  ]
  ++ lib.optional (zfs != null) zfs;

  trustedprefixes = writeText "kpmcore-trustedprefixes" (
    lib.concatStringsSep "\n" (map lib.getBin runtimeDeps)
  );
in

stdenv.mkDerivation (finalAttrs: {
  pname = "kpmcore";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kpmcore-${finalAttrs.version}.tar.xz";
    hash = "sha256-fi/zHFlAT+4DA2DBa+h3BuPpTDMi0XTDOjL7SbE9XVk=";
  };

  postPatch = ''
    cp ${trustedprefixes} src/util/trustedprefixes
  '';

  preConfigure = ''
    substituteInPlace src/util/CMakeLists.txt \
      --replace \$\{POLKITQT-1_POLICY_FILES_INSTALL_DIR\} $out/share/polkit-1/actions
    substituteInPlace src/backend/corebackend.cpp \
      --replace /usr/share/polkit-1/actions/org.kde.kpmcore.externalcommand.policy $out/share/polkit-1/actions/org.kde.kpmcore.externalcommand.policy
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    kcoreaddons
    ki18n
    kwidgetsaddons
    polkit-qt-1
  ];

  dontWrapQtApps = true;

  meta = {
    description = "KDE Partition Manager core library";
    homepage = "https://invent.kde.org/system/kpmcore";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
