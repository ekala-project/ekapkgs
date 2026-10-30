{
  lib,
  stdenv,
  fetchFromGitLab,
  getopt,
  lua,
  boost,
  libxcrypt,
  pkg-config,
  swig,
  perl,
}:

let
  luaInterp = lua.v5_2_compat;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "highlight";
  version = "4.21";

  strictDeps = true;

  src = fetchFromGitLab {
    owner = "saalen";
    repo = "highlight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lIfaiVM6M6RN4DeTGTdASNavFljyDRpts3a+N6I2gJY=";
  };

  nativeBuildInputs = [
    pkg-config
    swig
    perl
  ];

  buildInputs = [
    getopt
    luaInterp
    boost
    libxcrypt
  ];

  postPatch = ''
    substituteInPlace src/makefile \
      --replace "shell pkg-config" "shell $PKG_CONFIG"
    substituteInPlace makefile \
      --replace 'gzip' 'gzip -n'
  ''
  + lib.optionalString stdenv.cc.isClang ''
    substituteInPlace src/makefile \
        --replace 'CXX=g++' 'CXX=clang++'
  '';

  preConfigure = ''
    makeFlags="PREFIX=$out conf_dir=$out/etc/highlight/ CXX=$CXX AR=$AR"
  '';

  preBuild = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    make -C extras/swig $makeFlags perl
  '';

  postCheck = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    perl -Iextras/swig extras/swig/testmod.pl
  '';

  preInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    mkdir -p $out/${perl.libPrefix}
    install -m644 extras/swig/highlight.{so,pm} $out/${perl.libPrefix}
    make -C extras/swig clean
  '';

  meta = {
    description = "Source code highlighting tool";
    mainProgram = "highlight";
    homepage = "http://www.andre-simon.de/doku/highlight/en/highlight.php";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3Plus;
  };
})
