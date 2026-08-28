{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  jdk,
  cmake,
  ninja,
  pkg-config,
}:

let
  version = "4.13.2";

  source = fetchFromGitHub {
    owner = "antlr";
    repo = "antlr4";
    tag = version;
    sha256 = "sha256-DxxRL+FQFA+x0RudIXtLhewseU50aScHKSCDX7DE9bY=";
  };

  runtime = stdenv.mkDerivation {
    pname = "antlr-runtime-cpp";
    inherit version;
    src = source;

    patches = [
      ./include-dir-issue-379757.patch
    ];

    outputs = [
      "out"
      "dev"
    ];

    nativeBuildInputs = [
      cmake
      cmake.configurePhaseHook
      ninja
      pkg-config
    ];

    cmakeDir = "../runtime/Cpp";

    cmakeFlags = [
      (lib.cmakeBool "ANTLR4_INSTALL" true)
      (lib.cmakeBool "ANTLR_BUILD_CPP_TESTS" false)
    ];

    meta = {
      description = "C++ target for ANTLR 4";
      homepage = "https://www.antlr.org/";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.unix;
    };
  };
in

stdenv.mkDerivation {
  pname = "antlr";
  inherit version;

  src = fetchurl {
    url = "https://www.antlr.org/download/antlr-${version}-complete.jar";
    sha256 = "sha256-6uLfoRmmQydERnKv9j6ew1ogGA3FuAkLemq4USXfTXY=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p "$out"/{share/java,bin}
    ln -s "$src" "$out/share/java/antlr-${version}-complete.jar"

    echo "#! ${stdenv.shell}" >> "$out/bin/antlr"
    echo "'${jdk}/bin/java' -cp '$out/share/java/antlr-${version}-complete.jar:$CLASSPATH' -Xmx500M org.antlr.v4.Tool \"\$@\"" >> "$out/bin/antlr"

    echo "#! ${stdenv.shell}" >> "$out/bin/antlr-parse"
    echo "'${jdk}/bin/java' -cp '$out/share/java/antlr-${version}-complete.jar:$CLASSPATH' -Xmx500M org.antlr.v4.gui.Interpreter \"\$@\"" >> "$out/bin/antlr-parse"

    echo "#! ${stdenv.shell}" >> "$out/bin/grun"
    echo "'${jdk}/bin/java' -cp '$out/share/java/antlr-${version}-complete.jar:$CLASSPATH' org.antlr.v4.gui.TestRig \"\$@\"" >> "$out/bin/grun"

    chmod a+x "$out/bin/antlr" "$out/bin/antlr-parse" "$out/bin/grun"
    ln -s "$out/bin/antlr"{,4}
    ln -s "$out/bin/antlr"{,4}-parse
  '';

  inherit jdk;

  passthru = {
    inherit runtime;
    jarLocation = "/share/java/antlr-${version}-complete.jar";
  };

  meta = {
    description = "Powerful parser generator";
    homepage = "https://www.antlr.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
