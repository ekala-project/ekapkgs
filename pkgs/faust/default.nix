{
  lib,
  stdenv,
  coreutils,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  cmake,
  llvm,
  openssl,
  libsndfile,
  libmicrohttpd,
  libtool,
  libxml2,
  which,
  ncurses,
}:

let
  ncurses_static = ncurses.override { enableStatic = true; };
in
stdenv.mkDerivation {
  pname = "faust";
  version = "2.85.9";

  src = fetchFromGitHub {
    owner = "grame-cncm";
    repo = "faust";
    tag = "2.85.9";
    hash = "sha256-aUIbvMShhzi0QmFwZUOodzl3BY5TGt3TdquSeZ44C2k=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    cmake
    cmake.configurePhaseHook
    libtool
    which
  ];

  buildInputs = [
    llvm
    openssl
    libsndfile
    libmicrohttpd
    ncurses_static
    libxml2
  ];

  preConfigure = ''
    export PATH="${lib.getDev llvm}/bin:$PATH"
    cd build
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace Make.llvm.static \
      --replace-fail 'mkdir -p $@ && cd $@ && ar -x ../../$<' \
                    'mkdir -p $@ && cd $@ && ar -x ../source/build/lib/libfaust.a && cd ../source/build/'
    substituteInPlace Make.llvm.static \
      --replace-fail 'rm -rf $(TMP)' ' ' \
      --replace-fail " ar " " ${stdenv.cc.targetPrefix}ar "
    sed -i \
      's@LIBNCURSES_PATH ?= .*@LIBNCURSES_PATH ?= ${ncurses_static}/lib/libncurses.a@' \
      Make.llvm.static
  ''
  + ''
    shopt -s globstar
    for f in **/Makefile **/Makefile.library **/CMakeLists.txt build/Make.llvm.static source/tools/faust2appls/* **/llvm.cmake tools/benchmark/faust2object; do
      substituteInPlace $f \
        --replace-quiet "llvm-config" "llvm-config"
    done
    shopt -u globstar
    cd build
  '';

  cmakeFlags = [
    "-C../backends/all.cmake"
    "-C../targets/all.cmake"
  ];

  postInstall = ''
    pattern="faust2!(*@(atomsnippets|graph|graphviewer|md|plot|sig|sigviewer|svg))"
    (shopt -s extglob; rm "$out"/bin/$pattern)
  '';

  postFixup = ''
    substituteInPlace "$out"/bin/faustoptflags \
      --replace-fail uname "${coreutils}/bin/uname"
    for script in "$out"/bin/faust2*; do
      wrapProgram "$script" \
        --prefix PATH : "$out"/bin
    done
  '';

  meta = {
    homepage = "https://faust.grame.fr/";
    description = "Functional programming language for realtime audio signal processing";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    broken = true; # build/Make.llvm.static not found in source tree
  };
}
