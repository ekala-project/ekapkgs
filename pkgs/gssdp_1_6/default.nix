{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  vala,
  gi-docgen,
  python3,
  libsoup_3,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gssdp";
  version = "1.6.6";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gssdp/${lib.versions.majorMinor finalAttrs.version}/gssdp-${finalAttrs.version}.tar.xz";
    hash = "sha256-dn0idSVM4O/q6sZEGf+fTwrUcNE072cvXFVrKrt4a8s=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gobject-introspection
    vala
    gi-docgen
    python3
  ];

  buildInputs = [
    libsoup_3
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dsniffer=false"
    # This packages only has manpages for gssdp-device-sniffer, which we disabled above.
    "-Dmanpages=false"
  ];

  doCheck = true;

  postFixup = ''
    # Move developer documentation to devdoc output.
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    find -L "$out/share/doc" -type f -regex '.*\.devhelp2?' -print0 \
      | while IFS= read -r -d ''' file; do
        moveToOutput "$(dirname "''${file/"$out/"/}")" "$devdoc"
    done
  '';

  meta = {
    description = "GObject-based API for handling resource discovery and announcement over SSDP";
    homepage = "http://www.gupnp.org/";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
