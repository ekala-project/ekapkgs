{
  lib,
  stdenv,
  fetchgit,
  cmake,
  libjpeg,
  gtest,
}:

stdenv.mkDerivation {
  pname = "libyuv";
  version = "1908";

  src = fetchgit {
    url = "https://chromium.googlesource.com/libyuv/libyuv.git";
    rev = "b7a857659f8485ee3c6769c27a3e74b0af910746";
    hash = "sha256-4Irs+hlAvr6v5UKXmKHhg4IK3cTWdsFWxt1QTS0rizU=";
  };

  patches = [
    ./dither-honour-byte-order.patch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    "-DUNIT_TEST=ON"
  ];

  buildInputs = [
    libjpeg
    gtest
  ];

  postPatch = ''
    mkdir -p $out/lib/pkgconfig
    cp ${./yuv.pc} $out/lib/pkgconfig/libyuv.pc

    substituteInPlace $out/lib/pkgconfig/libyuv.pc \
      --replace "@PREFIX@" "$out" \
      --replace "@VERSION@" "$version"
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ./libyuv_unittest

    runHook postCheck
  '';

  meta = {
    homepage = "https://chromium.googlesource.com/libyuv/libyuv";
    description = "Open source project that includes YUV scaling and conversion functionality";
    mainProgram = "yuvconvert";
    platforms = lib.platforms.unix;
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
}
