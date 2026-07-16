{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  perl,
  pkg-config,
  asciidoc,
  xmlto,
  docbook_xml_dtd_45,
  docbook_xsl,
  libconfuse,
  yajl,
  alsa-lib,
  pulseaudio,
  libnl,
}:

let
  libpulseaudio = pulseaudio.override { libOnly = true; };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "i3status";
  version = "2.15";

  src = fetchurl {
    url = "https://i3wm.org/i3status/i3status-${finalAttrs.version}.tar.xz";
    hash = "sha256-bGf1LK5PE533ZK0cxzZWK+D5d1B5G8IStT80wG6vIgU=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    perl
    pkg-config
    asciidoc
    xmlto
    docbook_xml_dtd_45
    docbook_xsl
  ];

  buildInputs = [
    libconfuse
    yajl
    alsa-lib
    libpulseaudio
    libnl
  ];

  meta = {
    description = "Generates a status line for i3bar, dzen2, xmobar or lemonbar";
    homepage = "https://i3wm.org";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "i3status";
  };
})
