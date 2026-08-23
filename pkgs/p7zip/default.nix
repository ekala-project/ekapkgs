{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "p7zip";
  version = "17.06";

  src = fetchFromGitHub {
    owner = "p7zip-project";
    repo = "p7zip";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-NHlacZFal4xMYyFMshibeAw86cS1RXXyXweXKFHQAT8=";
    postFetch = ''
      rm -r $out/CPP/7zip/Compress/Rar*
      find $out -name makefile'*' -exec sed -i '/Rar/d' {} +
    '';
  };

  postPatch = ''
    sed -i '/CC=\/usr/d' makefile.macosx_llvm_64bits
    substituteInPlace install.sh --replace 'gzip' 'gzip -n'
    chmod +x install.sh
    sed -i '/XX=\/usr/d' makefile.macosx_llvm_64bits
  ''
  + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    substituteInPlace makefile.machine \
      --replace 'CC=gcc'  'CC=${stdenv.cc.targetPrefix}gcc' \
      --replace 'CXX=g++' 'CXX=${stdenv.cc.targetPrefix}g++'
  '';

  preConfigure = ''
    buildFlags=all3
  '';

  enableParallelBuilding = true;
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=c++11-narrowing";

  makeFlags = [
    "DEST_BIN=${placeholder "out"}/bin"
    "DEST_SHARE=${placeholder "lib"}/lib/p7zip"
    "DEST_MAN=${placeholder "man"}/share/man"
    "DEST_SHARE_DOC=${placeholder "doc"}/share/doc/p7zip"
  ];

  outputs = [
    "out"
    "lib"
    "doc"
    "man"
  ];

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "https://github.com/p7zip-project/p7zip";
    description = "New p7zip fork with additional codecs and improvements";
    license = with lib.licenses; [
      lgpl2Plus
      bsd3
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "7z";
  };
})
