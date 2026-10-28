{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  replaceVars,
  kauth,
  kcompletion,
  kcoreaddons,
  ki18n,
  kio,
  kwidgetsaddons,
  qcoro,
  samba,
  shadow,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdenetwork-filesharing";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kdenetwork-filesharing-${finalAttrs.version}.tar.xz";
    hash = "sha256-SArANNEYYRHdxlLhrqQZuY4y4U1dEUKR6DSyyz9wR10=";
  };

  patches = [
    (replaceVars ../../kde/gear/kdenetwork-filesharing/dependency-paths.patch {
      inherit samba;
      usermod = lib.getExe' shadow "usermod";
    })

    # Provide a more NixOS specific Samba hint
    ../../kde/gear/kdenetwork-filesharing/samba-hint.patch
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    kauth
    kcompletion
    kcoreaddons
    ki18n
    kio
    kwidgetsaddons
    qcoro
  ];

  # We can't actually install samba via PackageKit, so let's not confuse users any more than we have to
  cmakeEntries = {
    SAMBA_INSTALL = "OFF";
  };

  # Hardcoded as QStrings, which are UTF-16 so Nix can't pick these up automatically
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${samba} ${shadow}" > $out/nix-support/depends
  '';

  meta = {
    description = "Samba file sharing plugin for file properties";
    homepage = "https://apps.kde.org/kdenetwork-filesharing/";
    license = with lib.licenses; [
      bsd3
      gpl2Only
      gpl2Plus
      gpl3Only
      lgpl21Only
      lgpl3Only
    ];
    platforms = lib.platforms.linux;
  };
})
