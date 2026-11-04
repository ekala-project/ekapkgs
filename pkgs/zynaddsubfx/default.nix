{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  makeWrapper,
  pkg-config,
  # Required
  fftw,
  liblo,
  minixml,
  zlib,
  # Optional
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  dssiSupport ? false,
  dssi,
  ladspa-header,
  jackSupport ? true,
  libjack2,
  ossSupport ? true,
  portaudioSupport ? true,
  portaudio,
  # GUI
  guiModule ? "fltk",
  fltk,
  libjpeg,
  libxpm,
  libGL,
  libx11,
  # Tests
  cxxtest,
  ruby,
  ctestCheckHook,
}:

assert builtins.elem guiModule [
  "fltk"
  "off"
];

stdenv.mkDerivation (finalAttrs: {
  pname = "zynaddsubfx";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "zynaddsubfx";
    repo = "zynaddsubfx";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-0siAx141DZx39facXWmKbsi0rHBNpobApTdey07EcXg=";
  };

  outputs = [
    "out"
    "doc"
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/zynaddsubfx/zynaddsubfx/commit/853aa03f4f92a180b870fa62a04685d12fca55a7.patch";
      hash = "sha256-4BsRZ9keeqKopr6lCQJznaZ3qWuMgD1/mCrdMiskusg=";
    })
  ];

  postPatch = ''
    patchShebangs rtosc/test/test-port-checker.rb src/Tests/check-ports.rb
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    fftw.float
    liblo
    minixml
    zlib
  ]
  ++ lib.optionals alsaSupport [ alsa-lib ]
  ++ lib.optionals dssiSupport [
    dssi
    ladspa-header
  ]
  ++ lib.optionals jackSupport [ libjack2 ]
  ++ lib.optionals portaudioSupport [ portaudio ]
  ++ lib.optionals (guiModule == "fltk") [
    fltk
    libjpeg
    libxpm
  ];

  cmakeFlags = [
    "-DGuiModule=${guiModule}"
    "-DZYN_DATADIR=${placeholder "out"}/share/zynaddsubfx"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ]
  ++ lib.optional (!ossSupport) "-DOssEnable=OFF"
  ++ lib.optional (guiModule == "fltk") "-DFLTK_SKIP_OPENGL=ON";

  env.CXXFLAGS = toString [
    "-include cstdint"
  ];

  doCheck = true;

  nativeCheckInputs = [
    cxxtest
    ruby
    ctestCheckHook
  ];

  disabledTests = [
    "PortChecker"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    "MessageTest"
    "UnisonTest"
  ];

  meta = {
    description = "High quality software synthesizer";
    homepage = "https://zynaddsubfx.sourceforge.io";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "zynaddsubfx";
    broken = true; # mxml pkg-config version mismatch and missing deps
  };
})
