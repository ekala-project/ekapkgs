{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  vala,
  gi-docgen,
  gobject-introspection,
  glib,
  babl,
  libpng,
  cairo,
  libjpeg,
  librsvg,
  lensfun,
  libspiro,
  pango,
  poppler,
  bzip2,
  json-glib,
  gettext,
  meson,
  ninja,
  libraw,
  gexiv2,
  libwebp,
  openexr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gegl";
  version = "0.4.66";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];
  outputBin = "dev";

  src = fetchurl {
    url = "https://download.gimp.org/pub/gegl/${lib.versions.majorMinor finalAttrs.version}/gegl-${finalAttrs.version}.tar.xz";
    hash = "sha256-krBYVeIZCGiUnXDOpumlCxY6akQSQudApiY5dTefmTs=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    meson
    meson.configurePhaseHook
    ninja
    vala
    gobject-introspection
    gi-docgen
  ];

  buildInputs = [
    libpng
    cairo
    libjpeg
    librsvg
    lensfun
    libspiro
    pango
    poppler
    bzip2
    libraw
    libwebp
    gexiv2
    openexr
  ];

  propagatedBuildInputs = [
    glib
    json-glib
    babl
  ];

  mesonFeatures = {
    mrg = false;
    sdl2 = false;
    pygobject = false;
    libav = false;
    libv4l = false;
    libv4l2 = false;
    jasper = false;
    lua = false;
    maxflow = false;
    umfpack = false;
    vapigen = false;
  };

  postPatch = ''
    chmod +x tests/opencl/opencl_test.sh
    patchShebangs tests/ff-load-save/tests_ff_load_save.sh tests/opencl/opencl_test.sh tools/xml_insert.sh
  '';

  postFixup = ''
    moveToOutput "share/doc" "$devdoc"
  '';

  doCheck = false;

  meta = {
    description = "Graph-based image processing framework";
    homepage = "https://www.gegl.org";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
  };
})
