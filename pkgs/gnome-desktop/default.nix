{
  lib,
  stdenv,
  fetchurl,
  replaceVars,
  pkg-config,
  libxslt,
  ninja,
  gtk3,
  glib,
  gettext,
  libxml2,
  xkeyboard-config,
  libxkbcommon,
  isocodes,
  meson,
  wayland,
  libseccomp,
  udev,
  bubblewrap,
  gtk-doc,
  docbook-xsl-nons,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation rec {
  pname = "gnome-desktop";
  version = "44.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-desktop/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-rnylXcngiRSZl0FSOhfSnOIjkVYmvSRioSC/lvR6eas=";
  };

  patches = [
    (replaceVars ./bubblewrap-paths.patch {
      bubblewrap_bin = "${bubblewrap}/bin/bwrap";
      inherit (builtins) storeDir;
    })
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    gettext
    libxslt
    libxml2
    gtk-doc
    docbook-xsl-nons
    glib
  ];

  buildInputs = [
    xkeyboard-config
    libxkbcommon
    isocodes
    gtk3
    glib
    bubblewrap
    wayland
    libseccomp
    udev
  ];

  propagatedBuildInputs = [
    gsettings-desktop-schemas
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Ddesktop_docs=false"
    "-Dbuild_gtk4=false"
    "-Dintrospection=false"
    (lib.mesonEnable "systemd" false)
  ];

  separateDebugInfo = true;

  meta = {
    description = "Library with common API for various GNOME modules";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-desktop";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    platforms = lib.platforms.linux;
  };
}
