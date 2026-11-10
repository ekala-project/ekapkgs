{
  stdenv,
  lib,
  fetchurl,
  cmake,
  asLibrary ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "astyle";
  version = "3.6.19";

  src = fetchurl {
    url = "mirror://sourceforge/astyle/astyle-${finalAttrs.version}.tar.bz2";
    hash = "sha256-rl703fH4goi8yPbVMmZwf4CoH8xt7PTaX+XI5CCgqxw=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  # upstream repo includes a build/ directory
  cmakeBuildDir = "_build";

  cmakeEntries = lib.optionalAttrs asLibrary { BUILD_SHARED_LIBS = true; };

  postInstall = lib.optionalString asLibrary ''
    install -Dm444 ../src/astyle.h $out/include/astyle.h
  '';

  meta = {
    description = "Source code indenter, formatter, and beautifier for C, C++, C# and Java";
    mainProgram = "astyle";
    homepage = "https://astyle.sourceforge.net/";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
  };
})
