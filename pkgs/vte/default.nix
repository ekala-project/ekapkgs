{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  gettext,
  pkg-config,
  meson,
  ninja,
  glib,
  gtk3,
  python3,
  libxml2,
  gnutls,
  gperf,
  pango,
  pcre2,
  cairo,
  fribidi,
  zlib,
  icu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vte";
  version = "0.74.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/vte/${lib.versions.majorMinor finalAttrs.version}/vte-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-pTX7Kpj+qKJEnNGgLMz1GQEx3d/1LnFa/azj/rU26uc=";
  };

  patches = [
    (fetchpatch {
      name = "0001-Add-W_EXITCODE-macro-for-non-glibc-systems.patch";
      url = "https://git.alpinelinux.org/aports/plain/community/vte3/fix-W_EXITCODE.patch?id=4d35c076ce77bfac7655f60c4c3e4c86933ab7dd";
      sha256 = "FkVyhsM0mRUzZmS2Gh172oqwcfXv6PyD6IEgjBhy2uU=";
    })
  ];

  nativeBuildInputs = [
    gettext
    gperf
    libxml2
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    cairo
    fribidi
    gnutls
    pango
    pcre2
    zlib
    icu
  ];

  propagatedBuildInputs = [
    gtk3
    glib
    pango
  ];

  mesonFlags = [
    "-Ddocs=false"
    (lib.mesonBool "gtk3" true)
    (lib.mesonBool "gtk4" false)
    "-D_systemd=false"
    (lib.mesonBool "gir" false)
    (lib.mesonBool "vapi" false)
    (lib.mesonBool "glade" false)
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isMusl "-Wno-unused-command-line-argument";

  postPatch = ''
    patchShebangs perf/* || true
    patchShebangs src/box_drawing_generate.sh || true
    patchShebangs src/parser-seq.py
    patchShebangs src/modes.py
  '';

  meta = {
    homepage = "https://www.gnome.org/";
    description = "Library implementing a terminal emulator widget for GTK";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
