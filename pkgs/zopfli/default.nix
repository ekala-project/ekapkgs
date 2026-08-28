{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "zopfli";
  version = "1.0.3";
  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "zopfli";
    rev = "${pname}-${version}";
    name = "${pname}-${version}-src";
    sha256 = "0dr8n4j5nj2h9n208jns56wglw59gg4qm3s7c6y3hs75d0nnkhm4";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required(VERSION 2.8.11)' \
        'cmake_minimum_required(VERSION 3.10)'
  '';

  postInstall = ''
    install -Dm444 -t $out/share/doc/zopfli ../README*
    cp $src/src/zopfli/*.h $dev/include/
  '';

  meta = {
    description = "Very good, but slow, deflate or zlib compression";
    homepage = "https://github.com/google/zopfli";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    mainProgram = "zopfli";
  };
}
