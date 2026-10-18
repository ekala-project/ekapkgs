{
  version,
  src-hash,
  withIntrospection ? false,
  mkVariantPassthru,
  ...
}@variantArgs:

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
  inherit version;

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withIntrospection [
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gssdp/${lib.versions.majorMinor version}/gssdp-${version}.tar.xz";
    hash = src-hash;
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala
    gi-docgen
  ];

  buildInputs = [
    libsoup_3
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonEntries = {
    gtk_doc = withIntrospection;
    sniffer = false;
    manpages = false;
  } // lib.optionalAttrs (!withIntrospection) {
    introspection = false;
    vapi = false;
  };

  doCheck = true;

  postFixup = lib.optionalString withIntrospection ''
    # Move developer documentation to devdoc output.
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    find -L "$out/share/doc" -type f -regex '.*\.devhelp2?' -print0 \
      | while IFS= read -r -d ''' file; do
        moveToOutput "$(dirname "''${file/"$out/"/}")" "$devdoc"
    done
  '';

  passthru = mkVariantPassthru variantArgs;

  meta = {
    description = "GObject-based API for handling resource discovery and announcement over SSDP";
    homepage = "http://www.gupnp.org/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.all;
  };
})
