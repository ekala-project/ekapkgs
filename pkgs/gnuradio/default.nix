{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  removeReferencesTo,
  pkg-config,
  volk,
  cppunit,
  orc,
  boost,
  spdlog,
  mpir,
  doxygen,
  python3,
  codec2,
  gsm,
  fftwFloat ? null,
  alsa-lib,
  libjack2,
  libiio,
  libad9361,
  uhd,
  SDL,
  gsl,
  soapysdr,
  libsndfile,
  libunwind,
  thrift,
  cppzmq,
  # GUI related
  gtk3,
  pango,
  gobject-introspection,
  cairo,
  qt5,
  libsForQt5,
  # Features available to override
  features ? { },
}:

let
  python = python3;

  featuresInfo = {
    basic = {
      native = [
        cmake
        cmake.configurePhaseHook
        pkg-config
        orc
      ];
      runtime = [
        volk
        boost
        spdlog
        mpir
      ];
      pythonNative = with python.pythonOnBuildForHost.pkgs; [
        mako
      ];
    };
    doxygen = {
      native = [ doxygen ];
      cmakeEnableFlag = "DOXYGEN";
    };
    man-pages = {
      cmakeEnableFlag = "MANPAGES";
    };
    python-support = {
      native = [
        python
      ];
      cmakeEnableFlag = "PYTHON";
    };
    testing-support = {
      native = [ cppunit ];
      cmakeEnableFlag = "TESTING";
    };
    post-install = {
      cmakeEnableFlag = "POSTINSTALL";
    };
    gnuradio-runtime = {
      cmakeEnableFlag = "GNURADIO_RUNTIME";
      pythonRuntime = [
        python.pkgs.pybind11
      ];
    };
    gr-ctrlport = {
      runtime = [
        libunwind
        thrift
      ];
      pythonRuntime = [
        python.pkgs.thrift
        python.pkgs.matplotlib
        python.pkgs.networkx
      ];
      cmakeEnableFlag = "GR_CTRLPORT";
    };
    gnuradio-companion = {
      pythonRuntime = with python.pkgs; [
        pyyaml
        mako
        numpy
        pygobject3
      ];
      native = [
        python.pkgs.pytest
      ];
      runtime = [
        gtk3
        pango
        gobject-introspection
        cairo
        libsndfile
      ];
      cmakeEnableFlag = "GRC";
    };
    jsonyaml_blocks = {
      pythonRuntime = [
        python.pkgs.jsonschema
      ];
      cmakeEnableFlag = "JSONYAML_BLOCKS";
    };
    gr-blocks = {
      cmakeEnableFlag = "GR_BLOCKS";
      runtime = [
        libsndfile
      ];
    };
    gr-fec = {
      cmakeEnableFlag = "GR_FEC";
    };
    gr-fft = {
      runtime = [ fftwFloat ];
      cmakeEnableFlag = "GR_FFT";
    };
    gr-filter = {
      runtime = [ fftwFloat ];
      cmakeEnableFlag = "GR_FILTER";
      pythonRuntime = with python.pkgs; [
        scipy
        pyqt5
      ];
    };
    gr-analog = {
      cmakeEnableFlag = "GR_ANALOG";
    };
    gr-digital = {
      cmakeEnableFlag = "GR_DIGITAL";
    };
    gr-dtv = {
      cmakeEnableFlag = "GR_DTV";
    };
    gr-audio = {
      runtime = lib.optionals stdenv.hostPlatform.isLinux [
        alsa-lib
        libjack2
      ];
      cmakeEnableFlag = "GR_AUDIO";
    };
    gr-channels = {
      cmakeEnableFlag = "GR_CHANNELS";
    };
    gr-pdu = {
      cmakeEnableFlag = "GR_PDU";
    };
    gr-iio = {
      cmakeEnableFlag = "GR_IIO";
      runtime = [
        libiio
        libad9361
      ];
    };
    common-precompiled-headers = {
      cmakeEnableFlag = "COMMON_PCH";
    };
    gr-qtgui = {
      runtime = [
        qt5.qtbase
      ]
      ++ lib.optionals (libsForQt5 ? qwt) [
        libsForQt5.qwt
      ];
      pythonRuntime = [ python.pkgs.pyqt5 ];
      cmakeEnableFlag = "GR_QTGUI";
    };
    gr-trellis = {
      cmakeEnableFlag = "GR_TRELLIS";
    };
    gr-uhd = {
      runtime = [
        uhd
      ];
      cmakeEnableFlag = "GR_UHD";
    };
    gr-uhd-rfnoc = {
      runtime = [
        uhd
      ];
      cmakeEnableFlag = "UHD_RFNOC";
    };
    gr-utils = {
      cmakeEnableFlag = "GR_UTILS";
      pythonRuntime = with python.pkgs; [
        matplotlib
      ];
    };
    gr-modtool = {
      pythonRuntime =
        with python.pkgs;
        [
          click
        ]
        ++ lib.optionals (python.pkgs ? pygccxml) [
          python.pkgs.pygccxml
        ];
      cmakeEnableFlag = "GR_MODTOOL";
    };
    gr-blocktool = {
      cmakeEnableFlag = "GR_BLOCKTOOL";
    };
    gr-video-sdl = {
      runtime = [ SDL ];
      cmakeEnableFlag = "GR_VIDEO_SDL";
    };
    gr-vocoder = {
      runtime = [
        codec2
        gsm
      ];
      cmakeEnableFlag = "GR_VOCODER";
    };
    gr-wavelet = {
      cmakeEnableFlag = "GR_WAVELET";
      runtime = [
        gsl
      ];
    };
    gr-zeromq = {
      runtime = [ cppzmq ];
      cmakeEnableFlag = "GR_ZEROMQ";
      pythonRuntime = [
        python.pkgs.pyzmq
      ];
    };
    gr-network = {
      cmakeEnableFlag = "GR_NETWORK";
    };
    gr-soapy = {
      cmakeEnableFlag = "GR_SOAPY";
      runtime = [
        soapysdr
      ];
    };
  };

  hasFeature = feat: features.${feat} or true;

  enabledFeatures = lib.attrValues (lib.filterAttrs (feat: _: hasFeature feat) featuresInfo);

  cross = stdenv.hostPlatform != stdenv.buildPlatform;

  libgnuradioRuntime = "$(readlink -f $out/lib/libgnuradio-runtime${stdenv.hostPlatform.extensions.sharedLibrary})";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gnuradio";
  version = "3.10.12.0";

  src = fetchFromGitHub {
    owner = "gnuradio";
    repo = "gnuradio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-489Pc6z6Ha7jkTzZSEArDQJGkWdWRDIn1uhfFyLLiCo=";
  };

  patches = [
    # Not accepted upstream, see https://github.com/gnuradio/gnuradio/pull/5227
    ./modtool-newmod-permissions.patch

    # Finding `boost_system` fails because the stub compiled library of
    # Boost.System was removed in 1.89.
    (fetchpatch {
      url = "https://github.com/gnuradio/gnuradio/commit/d8814e0c3ef68372e5a1093603ef602e2119cd8a.patch";
      hash = "sha256-TQxqsce1AhSjdwaG2IP11QTeOgdJHN6cAAnznBl8eM8=";
    })
    # Needed for the patch below to apply
    (fetchpatch {
      url = "https://github.com/gnuradio/gnuradio/commit/56d230fd33fa2e8d6dc3685c9545589f21a6a1fd.patch";
      hash = "sha256-N6Y7B1EJKQxWlpu3E7sjNgivva8+x0V2DlBQMXYLXbA=";
    })
    # Fixes a test failing due to precision
    (fetchpatch {
      url = "https://github.com/gnuradio/gnuradio/commit/aee9fd3f79389c4282a98e8d62c8405c73fd91df.patch";
      hash = "sha256-UtYAJqqmydGs2EP4JOTGrQ6OgvL/jwGVwlhG4xxj8SU=";
    })
  ];

  nativeBuildInputs = [
    removeReferencesTo
  ]
  ++ lib.concatMap (info: info.native or [ ] ++ info.pythonNative or [ ]) enabledFeatures;

  buildInputs = lib.concatMap (
    info: info.runtime or [ ] ++ lib.optionals (hasFeature "python-support") (info.pythonRuntime or [ ])
  ) enabledFeatures;

  cmakeEntries = {
    CMAKE_CROSSCOMPILING = cross;
    PYBIND11_USE_CROSSCOMPILING = cross && hasFeature "gnuradio-runtime";
    ENABLE_DEFAULT = false;
  };

  cmakeFlags = lib.mapAttrsToList (
    feat: info: lib.cmakeBool "ENABLE_${info.cmakeEnableFlag}" (hasFeature feat)
  ) (lib.filterAttrs (feat: info: feat != "basic" && info ? cmakeEnableFlag) featuresInfo);

  # Wrapping is done with an external wrapper
  dontWrapPythonPrograms = true;
  dontWrapQtApps = true;

  postInstall =
    lib.optionalString (hasFeature "gnuradio-runtime") ''
      remove-references-to -t ${stdenv.cc} ${libgnuradioRuntime}
    ''
    + lib.optionalString (hasFeature "gnuradio-runtime" && stdenv.hostPlatform.isDarwin) ''
      remove-references-to -t ${stdenv.cc.cc} ${libgnuradioRuntime}
    ''
    + lib.optionalString (!hasFeature "python-support") ''
      remove-references-to -t ${python} $out/lib/cmake/gnuradio/GnuradioConfig.cmake
    ''
    + lib.optionalString (!hasFeature "python-support" && hasFeature "gnuradio-runtime") ''
      remove-references-to -t ${python} ${libgnuradioRuntime}
      remove-references-to -t ${python.pkgs.pybind11} $out/lib/cmake/gnuradio/gnuradio-runtimeTargets.cmake
    '';

  disallowedReferences = [
    stdenv.cc
    stdenv.cc.cc
  ]
  ++ lib.optionals (!hasFeature "python-support") [ python ];

  stripDebugList = [
    "lib"
    "bin"
  ]
  ++ lib.optionals (hasFeature "gr-audio") [ "share/gnuradio/examples/audio" ]
  ++ lib.optionals (hasFeature "gr-uhd") [ "share/gnuradio/examples/uhd" ]
  ++ lib.optionals (hasFeature "gr-qtgui") [ "share/gnuradio/examples/qt-gui" ];

  outputs = [
    "out"
  ]
  ++ lib.optionals (hasFeature "man-pages") [
    "man"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  preCheck = ''
    export QT_QPA_PLATFORM=offscreen
  ''
  + lib.optionalString (hasFeature "gr-qtgui") ''
    export QT_PLUGIN_PATH="${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}"
  '';

  passthru = {
    inherit
      uhd
      boost
      volk
      libiio
      libad9361
      python
      ;
    logLib = spdlog;
    inherit
      hasFeature
      featuresInfo
      ;
    versionAttr = {
      major = lib.versions.majorMinor finalAttrs.version;
      minor = lib.versions.patch finalAttrs.version;
      patch = lib.elemAt (lib.splitVersion finalAttrs.version) 3;
    };
    gnuradioOlder = lib.versionOlder finalAttrs.passthru.versionAttr.major;
    gnuradioAtLeast = lib.versionAtLeast finalAttrs.passthru.versionAttr.major;
  }
  // lib.optionalAttrs (hasFeature "gr-qtgui") {
    qt = qt5;
  }
  // lib.optionalAttrs (hasFeature "gnuradio-companion") {
    gtk = gtk3;
  };

  meta = {
    description = "Software Defined Radio (SDR) software";
    mainProgram = "gnuradio-config-info";
    longDescription = ''
      GNU Radio is a free & open-source software development toolkit that
      provides signal processing blocks to implement software radios. It can be
      used with readily-available low-cost external RF hardware to create
      software-defined radios, or without hardware in a simulation-like
      environment. It is widely used in hobbyist, academic and commercial
      environments to support both wireless communications research and
      real-world radio systems.
    '';
    homepage = "https://www.gnuradio.org";
    changelog = "https://github.com/gnuradio/gnuradio/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
  };
})
