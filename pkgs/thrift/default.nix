{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  boost,
  zlib,
  libevent,
  openssl,
  python3,
  cmake,
  pkg-config,
  bison,
  flex,
  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation rec {
  pname = "thrift";
  version = "0.18.1";

  src = fetchurl {
    url = "https://archive.apache.org/dist/thrift/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-BMbxDl14jKeOE+4u8NIVLHsHDAr1VIPWuULinP8pZyY=";
  };

  pythonPath = [ ];

  nativeBuildInputs = [
    bison
    cmake
    cmake.configurePhaseHook
    flex
    pkg-config
    python3
    python3.pkgs.setuptools
  ];

  buildInputs = [
    boost
  ];

  strictDeps = true;

  propagatedBuildInputs = [
    libevent
    openssl
    zlib
  ];

  postPatch = ''
    substituteInPlace test/py/RunClientServer.py \
      --replace "'FastbinaryTest.py'," "" \
      --replace "'TestEof.py'," "" \
      --replace "'TestFrozen.py'," ""

    substituteInPlace test/py/SerializationTest.py \
      --replace-fail "assertEquals" "assertEqual" \
      --replace-fail "assertNotEquals" "assertNotEqual"
  '';

  preConfigure = ''
    export PY_PREFIX=$out
  '';

  patches = [
    (fetchpatch {
      name = "setuptools-gte-62.1.0.patch";
      url = "https://github.com/apache/thrift/commit/c41ad9d5119e9bdae1746167e77e224f390f2c42.diff";
      hash = "sha256-FkErrg/6vXTomS4AsCsld7t+Iccc55ZiDaNjJ3W1km0=";
    })
    (fetchpatch {
      name = "thrift-install-FindLibevent.patch";
      url = "https://github.com/apache/thrift/commit/2ab850824f75d448f2ba14a468fb77d2594998df.diff";
      hash = "sha256-ejMKFG/cJgoPlAFzVDPI4vIIL7URqaG06/IWdQ2NkhY=";
    })
    (fetchpatch {
      name = "thrift-fix-tests-OpenSSL3.patch";
      url = "https://github.com/apache/thrift/commit/eae3ac418f36c73833746bcd53e69ed8a12f0e1a.diff";
      hash = "sha256-0jlN4fo94cfGFUKcLFQgVMI/x7uxn5OiLiFk6txVPzs=";
    })
  ];

  cmakeFlags = [
    "-DBUILD_JAVASCRIPT:BOOL=OFF"
    "-DBUILD_NODEJS:BOOL=OFF"
    "-DBUILD_TESTING:BOOL=OFF"
  ]
  ++ lib.optionals static [
    "-DWITH_STATIC_LIB:BOOL=ON"
    "-DOPENSSL_USE_STATIC_LIBS=ON"
  ];

  disabledTests = [
    "PythonTestSSLSocket"
    "PythonThriftTNonblockingServer"
  ];

  doCheck = false;

  checkPhase = ''
    runHook preCheck
    LD_LIBRARY_PATH=$PWD/lib ctest -E "($(echo "$disabledTests" | tr " " "|"))"
    runHook postCheck
  '';

  enableParallelChecking = false;

  meta = {
    description = "Library for scalable cross-language services";
    mainProgram = "thrift";
    homepage = "https://thrift.apache.org/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ ];
  };
}
