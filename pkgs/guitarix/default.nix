{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  avahi,
  bluez,
  boost,
  curl,
  eigen,
  fftwSinglePrec,
  gettext,
  glib,
  glib-networking,
  glibmm_2_4,
  gtk3,
  gtkmm3,
  hicolor-icon-theme,
  intltool,
  ladspa-header,
  libjack2,
  liblo,
  libsndfile,
  lilv,
  lrdf,
  lv2,
  pkg-config,
  python3,
  sassc,
  wafHook,
  wrapGAppsHook3,
  zita-convolver,
  zita-resampler,

  enableOptimization ? false,
  enableNSM ? true,
  enableSse ? stdenv.hostPlatform.isx86,
  withAvahi ? true,
  withBluez ? stdenv.hostPlatform.isLinux,
  withLiblo ? enableNSM,
  withZitaConvolver ? true,
  withZitaResampler ? true,
}:

assert enableNSM -> withLiblo;

stdenv.mkDerivation (finalAttrs: {
  pname = "guitarix";
  version = "0.47.0";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "guitarix";
    tag = "V${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-YQqcpdehfC9UE1OowC1/YUw2eWgbLWMbAJ3V5tVmtiU=";
  };

  sourceRoot = "${finalAttrs.src.name}/trunk";

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    hicolor-icon-theme
    intltool
    pkg-config
    python3
    sassc
    wafHook
    wrapGAppsHook3
  ];

  buildInputs = [
    boost
    curl
    eigen
    fftwSinglePrec
    gettext
    glib
    glib-networking.out
    glibmm_2_4
    gtk3
    gtkmm3
    ladspa-header
    libjack2
    libsndfile
    lilv
    lrdf
    lv2
  ]
  ++ lib.optional withAvahi avahi
  ++ lib.optional withBluez bluez
  ++ lib.optional withLiblo liblo
  ++ lib.optional withZitaConvolver zita-convolver
  ++ lib.optional withZitaResampler zita-resampler;

  patchFlags = [ "-p2" ];
  patches = [
    (fetchpatch2 {
      name = "make-boost-system-stub-optional.patch";
      url = "https://github.com/brummer10/guitarix/compare/v0.47.0..187670358ffc47a0fa09e140586b2e88dfdcf043.patch?full_index=1";
      hash = "sha256-9Z0sAM/oTm3ejv9chDbXEpkjNvlX/SN+k48XaJTqdy0=";
      includes = [
        "trunk/waf"
        "*/wscript"
        "trunk/waftools/*.py"
      ];
    })
  ];

  postPatch = ''
    patchShebangs --build tools/**
  '';

  wafConfigureFlags = [
    "--no-font-cache-update"
    "--shared-lib"
    "--no-desktop-update"
    "--enable-nls"
    "--install-roboto-font"
  ]
  ++ lib.optional (!enableNSM) "--no-nsm"
  ++ lib.optional enableOptimization "--optimization"
  ++ lib.optional (!enableSse) "--disable-sse"
  ++ lib.optional (!withAvahi) "--no-avahi"
  ++ lib.optional (!withBluez) "--no-bluez"
  ++ lib.optional (!withZitaConvolver) "--includeconvolver"
  ++ lib.optional (!withZitaResampler) "--includeresampler";

  meta = {
    description = "Virtual guitar amplifier for Linux running with JACK";
    mainProgram = "guitarix";
    homepage = "https://github.com/brummer10/guitarix";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
