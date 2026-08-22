{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  cmake,
  freedvSupport ? false,
  lpcnet ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "codec2";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "codec2";
    rev = finalAttrs.version;
    hash = "sha256-69Mp4o3MgV98Fqfai4txv5jQw2WpoPuoWcwHsNAFPQM=";
  };

  patches = [
    ./fix-pkg-config.patch
  ];

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    buildPackages.stdenv.cc
  ];

  buildInputs = lib.optionals freedvSupport [
    lpcnet
  ];

  # we need to unset these variables from stdenv here and then set their equivalents in the cmake flags
  # otherwise it will pass the same compiler to the native and cross phases and crash trying to execute
  # host binaries (generate_codebook) on the build system.
  preConfigure = ''
    unset CC
    unset CXX
  '';

  postInstall = ''
    install -Dm0755 src/{c2enc,c2dec,c2sim,freedv_rx,freedv_tx,cohpsk_*,fdmdv_*,fsk_*,ldpc_*,ofdm_*} -t $out/bin/
  '';

  postFixup =
    # Swap keyword order to satisfy SWIG parser
    ''
      sed -r -i 's/(\<_Complex)(\s+)(float|double)/\3\2\1/' $dev/include/$pname/freedv_api.h
    ''
    +
    # generated cmake module is not compatible with multiple outputs
    ''
      substituteInPlace $dev/lib/cmake/codec2/codec2-config.cmake --replace-fail \
        '"''${_IMPORT_PREFIX}/include/codec2' \
        "\"$dev/include/codec2"
    '';

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DCMAKE_C_COMPILER=${stdenv.cc.targetPrefix}cc"
    "-DCMAKE_CXX_COMPILER=${stdenv.cc.targetPrefix}c++"
  ]
  ++ lib.optionals freedvSupport [
    "-DLPCNET=ON"
  ];

  meta = {
    description = "Speech codec designed for communications quality speech at low data rates";
    homepage = "https://www.rowetel.com/codec2.html";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
