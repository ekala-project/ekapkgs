{
  lib,
  stdenv,
  qtModule,
  qtbase,
  qtmultimedia,
}:

qtModule {
  pname = "qtlocation";
  propagatedBuildInputs = [
    qtbase
    qtmultimedia
  ];
  outputs = [
    "bin"
    "out"
    "dev"
  ];
  # Clang 18 treats a non-const, narrowing conversion in an initializer list as an error,
  # which results in a failure building a 3rd party dependency of qtlocation. Just suppress it.
  env =
    lib.optionalAttrs (stdenv.cc.isClang && (lib.versionAtLeast (lib.getVersion stdenv.cc) "18"))
      {
        NIX_CFLAGS_COMPILE = "-Wno-c++11-narrowing-const-reference";
      };
}
