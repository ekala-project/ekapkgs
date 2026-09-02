{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  xfce4-dev-tools,
  wrapGAppsHook3,
  hicolor-icon-theme,
  perl,
  libice,
  libsm,
  libepoxy,
  libgtop,
  libgudev,
  libstartup_notification,
  xfconf,
  gtk3,
  libxfce4util,
}:

stdenv.mkDerivation rec {
  pname = "libxfce4ui";
  version = "4.20.1";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "libxfce4ui";
    rev = "libxfce4ui-${version}";
    sha256 = "sha256-CY9KCCbKBAuoYAJtPHlQj04dUuCZAovnyJsBgjzzQkI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    xfce4-dev-tools
    wrapGAppsHook3
    perl
  ];

  buildInputs = [
    hicolor-icon-theme
    libice
    libsm
    libepoxy
    libgtop
    libgudev
    libstartup_notification
    xfconf
  ];

  propagatedBuildInputs = [
    gtk3
    libxfce4util
  ];

  configureFlags = [
    "--enable-maintainer-mode"
    "--with-vendor-info=NixOS"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Widgets library for Xfce";
    homepage = "https://gitlab.xfce.org/xfce/libxfce4ui";
    mainProgram = "xfce4-about";
    license = with lib.licenses; [
      lgpl2Plus
      lgpl21Plus
    ];
    platforms = lib.platforms.linux;
  };
}
