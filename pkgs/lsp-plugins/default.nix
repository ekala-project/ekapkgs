{
  lib,
  stdenv,
  cairo,
  fetchurl,
  gst_all_1,
  libjack2,
  ladspa-header ? null,
  libGL,
  libGLU,
  libxrandr ? null,
  libsndfile,
  lv2,
  php84 ? null,
  php ? php84,
  pkg-config,

  buildVST3 ? true,
  buildVST2 ? true,
  buildCLAP ? true,
  buildLV2 ? true,
  buildLADSPA ? true,
  buildJACK ? true,
  buildGStreamer ? true,
}:

let
  subFeatures = [
    (lib.optionalString (!buildVST3) "vst3")
    (lib.optionalString (!buildVST2) "vst2")
    (lib.optionalString (!buildCLAP) "clap")
    (lib.optionalString (!buildLV2) "lv2")
    (lib.optionalString (!buildLADSPA) "ladspa")
    (lib.optionalString (!buildJACK) "jack")
    (lib.optionalString (!buildGStreamer) "gst")
  ];
in

stdenv.mkDerivation (finalAttrs: {
  pname = "lsp-plugins";
  version = "1.2.35";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchurl {
    url = "https://github.com/lsp-plugins/lsp-plugins/releases/download/${finalAttrs.version}/lsp-plugins-src-${finalAttrs.version}.tar.gz";
    hash = "sha256-LJXse7IZ1WHqPbNgUbbHMhM7zXZCb7g2sd2FDcS1u2w=";
  };

  postPatch = ''
    substituteInPlace modules/lsp-plugin-fw/src/Makefile \
      --replace-fail '$(shell pkg-config --variable=pluginsdir gstreamer-1.0)' '$(LIBDIR)/gstreamer-1.0'
  '';

  nativeBuildInputs = [
    php
    pkg-config
  ];

  buildInputs = [
    cairo
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    libjack2
    libGL
    libGLU
    libsndfile
    lv2
  ]
  ++ lib.optional (ladspa-header != null) ladspa-header
  ++ lib.optional (libxrandr != null) libxrandr;

  makeFlags = [
    "ETCDIR=${placeholder "out"}/etc"
    "PREFIX=${placeholder "out"}"
    "SHAREDDIR=${placeholder "out"}/share"
  ];

  env.NIX_CFLAGS_COMPILE = "-DLSP_NO_EXPERIMENTAL";

  configurePhase = ''
    runHook preConfigure

    make $makeFlags config SUB_FEATURES="${lib.concatStringsSep " " subFeatures}"

    runHook postConfigure
  '';

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    description = "Collection of open-source audio plugins";
    homepage = "https://lsp-plug.in";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
