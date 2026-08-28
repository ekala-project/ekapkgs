{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  speexdsp,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.2.6";
  pname = "libebur128";

  src = fetchFromGitHub {
    owner = "jiixyj";
    repo = "libebur128";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-UKO2k+kKH/dwt2xfaYMrH/GXjEkIrnxh1kGG/3P5d3Y=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];
  buildInputs = [ speexdsp ];

  postPatch = ''
    substituteInPlace ebur128/libebur128.pc.cmake \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@

    for file in CMakeLists.txt test/CMakeLists.txt; do
      substituteInPlace "$file" \
        --replace-fail \
          'cmake_minimum_required(VERSION 2.8.12' \
          'cmake_minimum_required(VERSION 3.10'
    done
  '';

  meta = {
    description = "Implementation of the EBU R128 loudness standard";
    homepage = "https://github.com/jiixyj/libebur128";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
