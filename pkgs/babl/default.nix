{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gi-docgen,
  gobject-introspection,
  lcms2,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "babl";
  version = "0.1.126";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "https://download.gimp.org/pub/babl/${lib.versions.majorMinor finalAttrs.version}/babl-${finalAttrs.version}.tar.xz";
    hash = "sha256-PwkPSyph/s98jcYKWAS7x3zv2Nd4ry3tBZ8ONnpSkw4=";
  };

  patches = [
    ./dev-prefix.patch
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gi-docgen
    gobject-introspection
    vala
  ];

  buildInputs = [
    lcms2
  ];

  strictDeps = true;

  mesonFlags = [
    "-Dprefix-dev=${placeholder "dev"}"
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-Dwith-docs=true"
    "-Denable-gir=true"
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  __structuredAttrs = true;

  meta = {
    description = "Image pixel format conversion library";
    mainProgram = "babl";
    homepage = "https://gegl.org/babl/";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
  };
})
