{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  libice,
  libsm,
  libx11,
  libxdmcp,
  libxext,
  libxinerama,
  libxrandr,
  libxtst,
  libei,
  libportal,
  openssl,
  pkg-config,
  qt6,
  gtk3,
  avahi,
  withLibei ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "input-leap";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "input-leap";
    repo = "input-leap";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zSaeeMlhpWIX3y4OmZ7eHXCu1HPP7NU5HFkME/JZjuQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    cmake.configurePhaseHook
    gtk3.wrapGAppsHook
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    curl
    qt6.qtbase
    avahi
    libx11
    libxext
    libxtst
    libxinerama
    libxrandr
    libxdmcp
    libice
    libsm
  ]
  ++ lib.optionals withLibei [
    libei
    libportal
  ];

  cmakeEntries = {
    INPUTLEAP_REVISION = "${builtins.substring 0 8 finalAttrs.src.rev}";
  };

  cmakeFlags = lib.optional withLibei "-DINPUTLEAP_BUILD_LIBEI=ON";

  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
        --prefix PATH : "${lib.makeBinPath [ openssl ]}"
    )
  '';

  meta = {
    description = "Open-source KVM software";
    longDescription = ''
      Input Leap is software that mimics the functionality of a KVM switch, which historically
      would allow you to use a single keyboard and mouse to control multiple computers by
      physically turning a dial on the box to switch the machine you're controlling at any
      given moment. Input Leap does this in software, allowing you to tell it which machine
      to control by moving your mouse to the edge of the screen, or by using a keypress
      to switch focus to a different system.
    '';
    homepage = "https://github.com/input-leap/input-leap";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
