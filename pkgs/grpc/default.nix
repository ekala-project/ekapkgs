{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  buildPackages,
  cmake,
  zlib,
  c-ares,
  pkg-config,
  re2,
  openssl,
  protobuf,
  grpc,
  abseil-cpp,
  libnsl,
}:

stdenv.mkDerivation rec {
  pname = "grpc";
  version = "1.71.0";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc";
    rev = "v${version}";
    hash = "sha256-QKSdMpfl0pdKy/r4z8VKcGN0gsQmx9lBRHlCjaaF5Sg=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      name = "grpc-link-libatomic.patch";
      url = "https://github.com/lopsided98/grpc/commit/a9b917666234f5665c347123d699055d8c2537b2.patch";
      hash = "sha256-Lm0GQsz/UjBbXXEE14lT0dcRzVmCKycrlrdBJj+KLu8=";
    })
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ]
  ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) grpc;

  propagatedBuildInputs = [
    c-ares
    re2
    zlib
    abseil-cpp
  ];

  buildInputs = [
    openssl
    protobuf
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ libnsl ];

  cmakeFlags = [
    "-DgRPC_ZLIB_PROVIDER=package"
    "-DgRPC_CARES_PROVIDER=package"
    "-DgRPC_RE2_PROVIDER=package"
    "-DgRPC_SSL_PROVIDER=package"
    "-DgRPC_PROTOBUF_PROVIDER=package"
    "-DgRPC_ABSL_PROVIDER=package"
    "-DBUILD_SHARED_LIBS=ON"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-D_gRPC_PROTOBUF_PROTOC_EXECUTABLE=${buildPackages.protobuf}/bin/protoc"
    "-D_gRPC_CPP_PLUGIN=${buildPackages.grpc}/bin/grpc_cpp_plugin"
  ];

  postPatch = ''
    # Fix missing include for std::any_of
    sed -i '1i #include <algorithm>' src/core/util/glob.cc
  '';

  preConfigure = ''
    rm -vf BUILD
  '';

  preBuild = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    export LD_LIBRARY_PATH=$(pwd)''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH
  '';

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "C based gRPC (C++, Python, Ruby, Objective-C, PHP, C#)";
    license = lib.licenses.asl20;
    maintainers = [ ];
    homepage = "https://grpc.io/";
    platforms = lib.platforms.all;
    changelog = "https://github.com/grpc/grpc/releases/tag/v${version}";
  };
}
