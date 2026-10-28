{
  lib,
  stdenv,
  fetchurl,
  cmake,
  llvmPackages,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "include-what-you-use";
  version = "0.26";

  src = fetchurl {
    url = "https://include-what-you-use.org/downloads/${finalAttrs.pname}-${finalAttrs.version}.src.tar.gz";
    hash = "sha256-UkfAyaWd+dFOiqdAj/7EE0xqSu8S9ZCSkRH7/qyTCgg=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    llvmPackages.llvm.dev
    llvmPackages.llvm
    python3
  ];
  buildInputs = [
    llvmPackages.libclang
    llvmPackages.clang-unwrapped
    python3
  ];

  clang = llvmPackages.clang;

  cmakeEntries = {
    CMAKE_PREFIX_PATH = "${llvmPackages.llvm.dev}";
  };

  postInstall = ''
    substituteInPlace $out/bin/iwyu_tool.py \
      --replace-fail "'include-what-you-use'" "'$out/bin/include-what-you-use'"

    mv $out/bin/include-what-you-use $out/bin/.include-what-you-use-unwrapped
    mv $out/bin/iwyu_tool.py $out/bin/.iwyu_tool.py-unwrapped
    substituteAll ${./wrapper} $out/bin/include-what-you-use
    ln -s $out/bin/include-what-you-use $out/bin/iwyu_tool.py
    chmod +x $out/bin/include-what-you-use
    patchShebangs $out/bin/include-what-you-use
  '';

  meta = {
    description = "Analyze #includes in C/C++ source files with clang";
    longDescription = ''
      For every symbol (type, function variable, or macro) that you use in
      foo.cc, either foo.cc or foo.h should #include a .h file that exports the
      declaration of that symbol.  The main goal of include-what-you-use is to
      remove superfluous #includes, both by figuring out what #includes are not
      actually needed for this file (for both .cc and .h files), and by
      replacing #includes with forward-declares when possible.
    '';
    homepage = "https://include-what-you-use.org";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
