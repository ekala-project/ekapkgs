{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gi-docgen,
  glib,
  json-glib,
  libsoup_3,
  libxml2,
  gobject-introspection,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librest";
  version = "0.10.2";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/librest/${lib.versions.majorMinor finalAttrs.version}/librest-${finalAttrs.version}.tar.xz";
    sha256 = "e2y5Ers6Is+n3PAFkl3LYogwJNsMCQmUhufWhRGFybg=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gi-docgen
    gobject-introspection
  ];

  propagatedBuildInputs = [
    glib
    json-glib
    libsoup_3
    libxml2
  ];

  mesonEntries = {
    examples = false;
    ca_certificates = true;
    ca_certificates_path = "/etc/ssl/certs/ca-certificates.crt";
  };

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  separateDebugInfo = true;

  meta = {
    description = "Helper library for RESTful services";
    homepage = "https://gitlab.gnome.org/GNOME/librest";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.unix;
  };
})
