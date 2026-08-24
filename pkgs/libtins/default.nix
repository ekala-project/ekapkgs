{
  boost,
  cmake,
  fetchFromGitHub,
  gtest,
  libpcap,
  openssl,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "libtins";
  version = "4.6";

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "libtins";
    rev = "v${version}";
    sha256 = "sha256-Y5cszXGAkpDBIRzu70IjtyxT5fAVhmIgbj5GVscDBtw=";
  };

  patches = [
    # Required for gtest 1.17+:
    # https://github.com/NixOS/nixpkgs/issues/425358
    # See also an upstream report for gtest 1.13+ and C++14:
    # https://github.com/mfontanini/libtins/issues/
    ./0001-force-cpp-17.patch
    # Update CMake minimum required version for CMake 4 compatibility
    # https://github.com/mfontanini/libtins/pull/553
  ];

  postPatch = ''
    rm -rf googletest
    cp -r ${gtest.src} googletest
    chmod -R a+w googletest
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    gtest
  ];
  buildInputs = [
    openssl
    libpcap
    boost
  ];

  cmakeFlags = [
    # CMake 4 dropped support of versions lower than 3.5,
    # versions lower than 3.10 are deprecated.
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10")
  ];

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--with-boost=${boost.dev}"
  ];

  doCheck = true;
  checkTarget = "tests test";

  meta = {
    description = "High-level, multiplatform C++ network packet sniffing and crafting library";
    homepage = "https://libtins.github.io/";
    changelog = "https://raw.githubusercontent.com/mfontanini/libtins/v${version}/CHANGES.md";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
