{
  lib,
  stdenv,
  fetchFromGitLab,
  autoconf,
  automake,
  gettext,
  intltool,
  libtool,
  pkg-config,
  wrapGAppsHook3,
  gobject-introspection,
  wayland-scanner,
  gtk3,

  withRandr ? true,
  libxcb,
  withDrm ? true,
  libdrm,
  withVidmode ? true,
  libxxf86vm,

  withGeoclue ? false,
  geoclue ? null,
  withAppIndicator ? false,
  libayatana-appindicator ? null,
}:

stdenv.mkDerivation rec {
  pname = "gammastep";
  version = "2.0.11";

  src = fetchFromGitLab {
    owner = "chinstrap";
    repo = "gammastep";
    rev = "v${version}";
    hash = "sha256-c8JpQLHHLYuzSC9bdymzRTF6dNqOLwYqgwUOpKcgAEU=";
  };

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    intltool
    libtool
    pkg-config
    wrapGAppsHook3
    gobject-introspection
    wayland-scanner
  ];

  configureFlags = [
    "--enable-randr=${lib.boolToYesNo withRandr}"
    "--enable-geoclue2=${lib.boolToYesNo withGeoclue}"
    "--enable-drm=${lib.boolToYesNo withDrm}"
    "--enable-vidmode=${lib.boolToYesNo withVidmode}"
    "--enable-quartz=no"
    "--enable-corelocation=no"
    "--with-systemduserunitdir=${placeholder "out"}/lib/systemd/user/"
    "--enable-apparmor"
  ];

  buildInputs = [
    gtk3
  ]
  ++ lib.optional withRandr libxcb
  ++ lib.optional withGeoclue geoclue
  ++ lib.optional withDrm libdrm
  ++ lib.optional withVidmode libxxf86vm
  ++ lib.optional withAppIndicator libayatana-appindicator;

  preConfigure = "./bootstrap";

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall = ''
    if [ -f $out/share/applications/gammastep.desktop ]; then
      substituteInPlace $out/share/applications/gammastep.desktop \
        --replace 'Exec=gammastep' "Exec=$out/bin/gammastep"
    fi
    if [ -f $out/share/applications/gammastep-indicator.desktop ]; then
      substituteInPlace $out/share/applications/gammastep-indicator.desktop \
        --replace 'Exec=gammastep-indicator' "Exec=$out/bin/gammastep-indicator"
    fi
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Screen color temperature manager";
    longDescription = ''
      Gammastep adjusts the color temperature according to the position
      of the sun. A different color temperature is set during night and
      daytime. During twilight and early morning, the color temperature
      transitions smoothly from night to daytime temperature to allow
      your eyes to slowly adapt. At night the color temperature should
      be set to match the lamps in your room.
    '';
    homepage = "https://gitlab.com/chinstrap/gammastep";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "gammastep";
  };
}
