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
  glib,
  gssdp,
  libsoup_3,
  libxml2,
}:

let
  gssdpPkg = if withIntrospection then gssdp.v1_6 else gssdp;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "gupnp";
  inherit version;

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withIntrospection [
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp/${lib.versions.majorMinor version}/gupnp-${version}.tar.xz";
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
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala
    gi-docgen
  ];

  propagatedBuildInputs = [
    glib
    gssdpPkg
    libsoup_3
    libxml2
  ];

  mesonEntries = {
    gtk_doc = withIntrospection;
  } // lib.optionalAttrs (!withIntrospection) {
    introspection = false;
    vapi = false;
  };

  doCheck = true;

  postFixup = lib.optionalString withIntrospection ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = mkVariantPassthru variantArgs;

  meta = {
    homepage = "http://www.gupnp.org/";
    description = "Implementation of the UPnP specification";
    mainProgram = "gupnp-binding-tool-1.6";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
