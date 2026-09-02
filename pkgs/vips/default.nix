{
  lib,
  stdenv,
  fetchFromGitHub,
  docbook-xsl-nons,
  gtk-doc,
  meson,
  ninja,
  pkg-config,
  expat,
  glib,
  libxml2,
  # Optional dependencies
  cfitsio,
  fftw,
  imagemagick,
  lcms2,
  libarchive,
  libexif,
  libheif,
  libhwy,
  libimagequant,
  libjpeg,
  libjxl,
  librsvg,
  libspng,
  libtiff,
  libwebp,
  matio,
  openexr,
  openjpeg,
  pango,
  poppler,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vips";
  version = "8.16.1";

  outputs = [
    "bin"
    "out"
    "man"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitHub {
    owner = "libvips";
    repo = "libvips";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F2ymfvqwuCtNtFIOLgXvqRWATSMaeV7EQKYyQalCNfc=";
    postFetch = ''
      rm -r $out/test/test-suite/images/
    '';
  };

  nativeBuildInputs = [
    docbook-xsl-nons
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gtk-doc
  ];

  buildInputs = [
    glib
    libxml2
    expat

    # Optional dependencies
    cfitsio
    fftw
    imagemagick
    lcms2
    libarchive
    libexif
    libheif
    libhwy
    libimagequant
    libjpeg
    libjxl
    librsvg
    libspng
    libtiff
    libwebp
    matio
    openexr
    openjpeg
    pango
    poppler
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    (lib.mesonEnable "pdfium" false)
    (lib.mesonEnable "nifti" false)
    (lib.mesonEnable "introspection" false)
    (lib.mesonEnable "cgif" false)
    (lib.mesonEnable "openslide" false)
    (lib.mesonBool "gtk_doc" true)
  ];

  meta = {
    homepage = "https://www.libvips.org/";
    description = "Image processing system for large images";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "vips";
  };
})
