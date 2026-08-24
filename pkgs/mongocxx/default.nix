{
  lib,
  stdenv,
  fetchFromGitHub,
  mongoc,
  openssl,
  cyrus_sasl,
  cmake,
  validatePkgConfig,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mongocxx";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-cxx-driver";
    tag = "r${finalAttrs.version}";
    hash = "sha256-QRVzYX6x29Fpc1hLFYbFkdOVGpWiyRS5jAAABHHAU78=";
  };

  postPatch = ''
    substituteInPlace src/bsoncxx/cmake/libbsoncxx.pc.in \
      src/mongocxx/cmake/libmongocxx.pc.in \
      --replace "\''${prefix}/" ""
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    validatePkgConfig
  ];

  buildInputs = [
    mongoc
    openssl
    cyrus_sasl
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_STANDARD=20"
    "-DBUILD_VERSION=${finalAttrs.version}"
    "-DENABLE_UNINSTALL=OFF"
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Official C++ client library for MongoDB";
    homepage = "http://mongocxx.org";
    license = lib.licenses.asl20;
    maintainers = [ ];
    pkgConfigModules = [
      "libmongocxx"
      "libbsoncxx"
    ];
    platforms = lib.platforms.all;
  };
})
