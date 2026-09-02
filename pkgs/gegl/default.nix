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
  version = "0.4.62";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];
  outputBin = "dev";

  src = fetchurl {
    url = "https://download.gimp.org/pub/gegl/${lib.versions.majorMinor finalAttrs.version}/gegl-${finalAttrs.version}.tar.xz";
    hash = "sha256-WIdXY3Hr8dnpB5fRDkuafxZYIo1IJ1g+eeHbPZRQXGw=";
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

  mesonFlags = [
    "-Dmrg=disabled"
    "-Dsdl2=disabled"
    "-Dpygobject=disabled"
    "-Dlibav=disabled"
    "-Dlibv4l=disabled"
    "-Dlibv4l2=disabled"
    "-Djasper=disabled"
    "-Dlua=disabled"
    "-Dmaxflow=disabled"
    "-Dumfpack=disabled"
  ];

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
